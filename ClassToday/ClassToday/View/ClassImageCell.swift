//
//  ClassImageEnrollCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit
import SnapKit

protocol ClassImageCellDelegate {
    func deleteImageCell(indexPath: IndexPath)
}

class ClassImageCell: UICollectionViewCell {
    static let identifier = "ClassImageCell"
    var delegate: ClassImageCellDelegate?
    private var indexPath: IndexPath?

    private lazy var classImageView: ClassImageView = {
        let imageView = ClassImageView()
        imageView.delegate = self
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
            make.edges.equalToSuperview()
        }
    }
    
    func configureWith(image: UIImage, indexPath: IndexPath) {
        self.indexPath = indexPath
        classImageView.configureWith(image: image)
    }
}

extension ClassImageCell: ClassImageViewDelegate {
    func deleteClicked() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteImageCell(indexPath: indexPath)
    }
}
