//
//  ClassCategoryCollectionReusableView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/02.
//

import UIKit

class ClassCategoryCollectionReusableView: UICollectionReusableView {

    // MARK: Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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

    // MARK: Properties

    static let identifier = "ClassCategoryCollectionReusableView"
    static let height = 36

    // MARK: Initialize

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

        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }

        supplementaryLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(titleLabel.snp.centerY).offset(3)
        }
    }

    func configure(with categoryType: CategoryType) {
        switch categoryType {
        case .subject:
            titleLabel.text = "수업 카테고리"
        case .target:
            titleLabel.text = "수업 대상"
        }
    }
}
