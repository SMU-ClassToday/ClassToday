//
//  PriceUnitTableView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/07.
//

import UIKit
import SnapKit

protocol PriceUnitTableViewDelegate: AnyObject {
    func selectedPriceUnit(priceUnit: PriceUnit)
}

class PriceUnitTableView: UIView {

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PriceUnitTableViewCell.self, forCellReuseIdentifier: PriceUnitTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = PriceUnitTableViewCell.height
        tableView.isScrollEnabled  = false
        return tableView
    }()

    // MARK: - Properties

    weak var delegate: PriceUnitTableViewDelegate?

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-16)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}

// MARK: - TableViewDataSource

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

// MARK: - TableViewDelegate

extension PriceUnitTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let priceUnit = PriceUnit.allCases[indexPath.row]
        delegate?.selectedPriceUnit(priceUnit: priceUnit)
    }
}
