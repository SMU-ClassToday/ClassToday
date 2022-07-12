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

class MapClassListView: UIView {

    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주변의 인기있는 수업"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MapClassListCell.self, forCellReuseIdentifier: MapClassListCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
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
        addSubview(tableView)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
        
    }
}
