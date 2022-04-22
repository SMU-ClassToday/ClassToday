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
        label.backgroundColor = .mainColor
        label.clipsToBounds = true
        return label
    }()
    
    func setupView(subject: Subject, fontSize: CGFloat) {
        layout()
        setupSubjectLabel(subject: subject.text, fontSize: fontSize)
    }
}

private extension SubjectCollectionViewCell {
    func setupSubjectLabel(subject: String ,fontSize: CGFloat) {
        subjectLabel.text = subject
        subjectLabel.font = .systemFont(ofSize: fontSize, weight: .semibold)
        subjectLabel.layer.cornerRadius = fontSize
    }
    func layout() {
        contentView.addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
