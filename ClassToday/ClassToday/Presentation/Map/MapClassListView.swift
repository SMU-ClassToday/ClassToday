//
//  MapClassListView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/09.
//

import UIKit

protocol MapClassListViewDelegate: AnyObject {
    func presentViewController(with classItem: ClassItem)
}

final class MapClassListTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
    override func layoutSubviews() {
      self.invalidateIntrinsicContentSize()
      super.layoutSubviews()
    }
}

class MapClassListView: UIView {

    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주변의 인기있는 수업"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var listView: MapClassListTableView = {
        let tableView = MapClassListTableView()
        tableView.register(MapClassListCell.self, forCellReuseIdentifier: MapClassListCell.identifier)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        return tableView
    }()
    
    // MARK: - Properties
    private var datas: [ClassItem] = []
    weak var delegate: MapClassListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        addSubview(titleLabel)
        addSubview(listView)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(12)
        }
        listView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        listView.invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }

    func configure(with datas: [ClassItem]) {
        self.datas = datas
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.listView.reloadData()
        }
    }
}

extension MapClassListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapClassListCell.identifier, for: indexPath) as? MapClassListCell else {
            fatalError()
        }
        cell.configure(with: datas[indexPath.row])
        return cell
    }
}

extension MapClassListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.presentViewController(with: datas[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
