//
//  DetailContentCategoryCollectionViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentCategoryCollectionViewCell: UICollectionViewCell {

    // MARK: - Views

    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 13
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.numberOfLines = 1
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
        return button
    }()

    // MARK: - Properties

    static let identifier = "DetailContentCategoryCollectionViewCell"
    static let height = CGFloat(32)

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
        contentView.addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    func configureWith(category: CategoryItem) {
        categoryButton.setTitle(category.description, for: .normal)
    }
}
