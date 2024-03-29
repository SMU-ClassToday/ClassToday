//
//  CategoryListCollectionViewCell.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/25.
//

import UIKit
import SnapKit

class CategoryListCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryListCollectionViewCell"
    
    //MARK: - cell 내부 UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.text = "test"
        categoryLabel.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return categoryLabel
    }()

    // MARK: Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 이후에 이미지 설정도 여기서 진행
    func configureWith(categoryItem: CategoryItem) {
        categoryLabel.text = categoryItem.description
        if let categoryItem = categoryItem as? Subject {
            imageView.image = categoryItem.image
        }
    }

}

//MARK: - set autolayout
private extension CategoryListCollectionViewCell {
    func layout() {
        [
            imageView,
            categoryLabel
        ].forEach { contentView.addSubview($0)}
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(imageView)
        }
    }
}
