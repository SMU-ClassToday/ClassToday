//
//  PriceUnitTableViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/07.
//

import UIKit
import SnapKit

class PriceUnitTableViewCell: UITableViewCell {

    // MARK: - Views

    private lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Properties

    static let identifier = "PriceUnitTableViewCell"
    static let height: CGFloat = 40.0

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(32)
        }
    }

    func configureWith(priceUnit: PriceUnit) {
        label.text = priceUnit.description
    }
}
