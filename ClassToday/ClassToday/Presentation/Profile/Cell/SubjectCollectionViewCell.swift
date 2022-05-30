//
//  SubjectCollectionViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class SubjectCollectionViewCell: UICollectionViewCell {
    static let identifier = "SubjectCollectionViewCell"
    
    private lazy var subjectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    func setupView(subject: Subject, font: UIFont) {
        attribute()
        layout()
        setupSubjectLabel(subject: subject.description, font: font)
    }
}

private extension SubjectCollectionViewCell {
    func setupSubjectLabel(subject: String ,font: UIFont) {
        subjectLabel.text = subject
        subjectLabel.font = font
    }
    func attribute() {
        contentView.layer.cornerRadius = contentView.frame.height / 2.0
        contentView.backgroundColor = .mainColor
    }
    func layout() {
        contentView.addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
