//
//  ClassImageEnrollCellCollectionViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit

class ClassImageEnrollCell: UICollectionViewCell {
    static let identifier = "ClassImageEnrollCell"
    private lazy var classImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var imageCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
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
        contentView.addSubview(imageCountLabel)
        classImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        imageCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.centerY).offset(30)
        }

        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configureWith(count: Int) {
        classImageView.image = UIImage(systemName: "plus")
        imageCountLabel.text = "\(count) / 5"
    }
}
