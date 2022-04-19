//
//  ClassImageEnrollCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit
import SnapKit

class ClassImageCell: UICollectionViewCell {
    static let identifier = "ClassImageCell"
    private lazy var classImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        contentView.addSubview(classImageView)
        classImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configureWith(image: UIImage) {
        classImageView.image = image
    }
}
