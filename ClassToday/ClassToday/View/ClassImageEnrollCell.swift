//
//  ClassImageEnrollCellCollectionViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit

class ClassImageEnrollCell: UICollectionViewCell {
    static let identifier = "ClassImageEnrollCell"
    private let limitImageCount = 8
    private lazy var classImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var imageCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
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
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.3)
        }
        imageCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.centerY).offset(30)
        }

        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
    }

    func configureWith(count: Int) {
        classImageView.image = UIImage(systemName: "camera")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageCountLabel.text = "\(count) / \(limitImageCount)"
    }
}
