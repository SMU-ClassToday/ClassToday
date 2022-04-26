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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
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
    
    func setupView() {
        layout()
    }
}

private extension CategoryListCollectionViewCell {
    func layout() {
        [
            imageView,
            categoryLabel
        ].forEach { contentView.addSubview($0)}
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(imageView.snp.height)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(imageView)
        }
    }
}
