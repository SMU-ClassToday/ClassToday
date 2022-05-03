//
//  ClassEnrollCategoryViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/29.
//

import UIKit

class ClassEnrollCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "ClassEnrollCategoryCollectionViewCell"
    static let height: CGFloat = 40.0

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.addTarget(self, action: #selector(clicked(_:)), for: .touchDown)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(button)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.leading.equalTo(contentView.snp.leading).offset(8)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.bottom.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing).offset(-4)
        }
    }
    
    func configure(with category: CategoryItem) {
        nameLabel.text = category.name
    }
    
    @objc func clicked(_ button: UIButton) {
        if button.isSelected {
            button.isSelected = false
        } else {
            button.isSelected = true
        }
    }
}