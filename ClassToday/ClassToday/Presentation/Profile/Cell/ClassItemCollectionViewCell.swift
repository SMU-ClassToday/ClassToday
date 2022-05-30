//
//  ClassItemCollectionViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class ClassItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ClassItemCollectionViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupView() {
        layout()
    }
}

private extension ClassItemCollectionViewCell {
    func layout() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
