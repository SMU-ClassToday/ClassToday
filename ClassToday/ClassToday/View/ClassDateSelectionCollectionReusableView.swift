//
//  ClassDateSelectionCollectionReusableView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/06.
//

import UIKit

class ClassDateSelectionCollectionReusableView: UICollectionReusableView {
    static let identifier = "ClassDateSelectionCollectionReusableView"
    static let height = 36
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수업 요일"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var supplementaryLabel: UILabel = {
        let label = UILabel()
        label.text = "중복선택 가능"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
        self.addSubview(titleLabel)
        self.addSubview(supplementaryLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.centerY.equalTo(self.snp.centerY)
        }
        supplementaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY).offset(3)
        }
    }
}
