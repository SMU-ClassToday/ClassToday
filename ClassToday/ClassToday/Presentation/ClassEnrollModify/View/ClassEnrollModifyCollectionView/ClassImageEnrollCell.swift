//
//  ClassImageEnrollCellCollectionViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit

class ClassImageEnrollCell: UICollectionViewCell {

    // MARK: - Views

    private lazy var classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return imageView
    }()

    private lazy var imageCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()

    // MARK: - Properties

    static let identifier = "ClassImageEnrollCell"
    private let limitImageCount = 8

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Method

    private func configureUI() {
        contentView.addSubview(classImageView)
        contentView.addSubview(imageCountLabel)

        classImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }

        imageCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30)
        }

        contentView.layer.cornerRadius = 30
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
    }

    func configureWith(count: Int) {
        imageCountLabel.text = "\(count) / \(limitImageCount)"
    }
}
