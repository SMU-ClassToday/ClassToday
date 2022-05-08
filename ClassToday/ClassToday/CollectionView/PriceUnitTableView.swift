//
//  PriceUnitTableView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/07.
//

import UIKit
import SnapKit

protocol PriceUnitTableViewDelegate {
    func selectedPriceUnit(priceUnit: PriceUnit)
}

class PriceUnitTableView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PriceUnitTableViewCell.self, forCellReuseIdentifier: PriceUnitTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = PriceUnitTableViewCell.height
        tableView.isScrollEnabled  = false
        return tableView
    }()
    var delegate: PriceUnitTableViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(-16)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}

extension PriceUnitTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PriceUnit.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PriceUnitTableViewCell.identifier, for: indexPath) as? PriceUnitTableViewCell else {
            return UITableViewCell()
        }
        cell.configureWith(priceUnit: PriceUnit.allCases[indexPath.row])
        return cell
    }
}

extension PriceUnitTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let priceUnit = PriceUnit.allCases[indexPath.row]
        delegate?.selectedPriceUnit(priceUnit: priceUnit)
    }
}
