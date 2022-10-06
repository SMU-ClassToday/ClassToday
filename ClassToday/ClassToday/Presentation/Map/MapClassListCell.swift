//
//  MapClassListCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/09.
//

import UIKit

class MapClassListCell: UITableViewCell {

    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var recommendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    static let identifier = "MapClassListCell"
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with classItem: ClassItem) {
        titleLabel.text = classItem.name
        addressLabel.text = "\(classItem.keywordLocation ?? "") \(classItem.semiKeywordLocation ?? "") "
        timeLabel.text = classItem.pastDateCalculate()
        priceUnitLabel.isHidden = false
        if let price = classItem.price {
            costLabel.text = "\(price)원"
            priceUnitLabel.text = classItem.priceUnit.description
        } else {
            priceUnitLabel.isHidden = true
            costLabel.text = "가격협의"
        }
    }

    private func setUpLayout() {
        [titleLabel, addressLabel, timeLabel, costLabel, priceUnitLabel, countLabel, recommendLabel].forEach { self.addSubview($0)}
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(8)
            $0.leading.equalTo(self.snp.leading).offset(12)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(self.snp.bottom).offset(-8)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.top)
            $0.leading.equalTo(addressLabel.snp.trailing)
            $0.bottom.equalTo(addressLabel.snp.bottom)
        }
        recommendLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-8)
            $0.bottom.equalTo(self.snp.bottom)
        }
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(recommendLabel.snp.leading)
            $0.bottom.equalTo(recommendLabel.snp.bottom)
        }
        costLabel.snp.makeConstraints {
            $0.trailing.equalTo(countLabel.snp.leading)
            $0.bottom.equalTo(recommendLabel.snp.bottom)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(costLabel.snp.leading).offset(-4)
            $0.bottom.equalTo(recommendLabel.snp.bottom)
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        addressLabel.text = nil
        timeLabel.text = nil
        costLabel.text = nil
        countLabel.text = nil
        recommendLabel.text = nil
    }
}
