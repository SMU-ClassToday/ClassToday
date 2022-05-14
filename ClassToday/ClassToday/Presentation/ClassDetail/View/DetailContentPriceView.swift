//
//  DetailContentPriceView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentPriceView: UIView {

    // MARK: - Views

    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "수업가격"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .black
        return sepertor
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    // MARK: - Intialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        self.addSubview(headLabel)
        self.addSubview(priceUnitLabel)
        self.addSubview(seperator)
        self.addSubview(priceLabel)

        headLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.bottom.equalTo(headLabel.snp.bottom)
            $0.leading.equalTo(headLabel.snp.trailing).offset(8)
        }
        seperator.snp.makeConstraints {
            $0.top.equalTo(headLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(seperator.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureWith(priceUnit: PriceUnit, price: String) {
        priceUnitLabel.text = priceUnit.description
        priceLabel.text = price.formattedWithWon()
    }
}
