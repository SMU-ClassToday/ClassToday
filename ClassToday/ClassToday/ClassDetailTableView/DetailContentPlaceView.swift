//
//  DetailContentPlaceView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/09.
//

import UIKit

class DetailContentPlaceView: UIView {
    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "수업장소"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .black
        return sepertor
    }()
    
    private lazy var placeLabel: UILabel = {
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
        self.addSubview(seperator)
        self.addSubview(placeLabel)

        headLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        seperator.snp.makeConstraints { make in
            make.top.equalTo(headLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    func configureWith(place: String) {
        placeLabel.text = place
    }
}
