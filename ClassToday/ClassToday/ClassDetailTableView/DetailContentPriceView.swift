//
//  DetailContentPriceView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentPriceView: UIView {
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "수업가격"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .black
        return sepertor
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(headLabel)
        self.addSubview(priceUnitLabel)
        self.addSubview(seperator)
        self.addSubview(priceLabel)
        
        headLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
        }
        priceUnitLabel.snp.makeConstraints { make in
            make.bottom.equalTo(headLabel.snp.bottom)
            make.leading.equalTo(headLabel.snp.trailing).offset(16)
        }
        seperator.snp.makeConstraints { make in
            make.top.equalTo(headLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    func configureWith(priceUnit: PriceUnit, price: String) {
        priceUnitLabel.text = priceUnit.description
        priceLabel.text = price.formmatedWithCurrency()
    }
}
