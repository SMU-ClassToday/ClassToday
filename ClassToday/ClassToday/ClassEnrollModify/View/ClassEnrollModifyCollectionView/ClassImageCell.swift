//
//  ClassImageEnrollCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit
import SnapKit

protocol ClassImageCellDelegate: AnyObject {
    func deleteImageCell(indexPath: IndexPath)
}

class ClassImageCell: UICollectionViewCell {

    // MARK: Views
    private lazy var classImageView: ClassImageView = {
        let imageView = ClassImageView()
        imageView.delegate = self
        return imageView
    }()

    // MARK: Properties

    weak var delegate: ClassImageCellDelegate?
    static let identifier = "ClassImageCell"
    private var indexPath: IndexPath?

    // MARK: Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        contentView.addSubview(classImageView)
        classImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureWith(image: UIImage, indexPath: IndexPath) {
        self.indexPath = indexPath
        classImageView.configureWith(image: image)
    }
}

// MARK: ClassImageViewDelegate

extension ClassImageCell: ClassImageViewDelegate {
    func deleteClicked() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteImageCell(indexPath: indexPath)
    }
}
