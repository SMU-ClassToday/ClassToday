//
//  SubjectPickerCollectionViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import UIKit
import SnapKit

class SubjectPickerCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "SubjectPickerCollectionViewCell"
    var isCheck: Bool = false
    
    // MARK: - UI Components
    private lazy var titleLabel = UILabel()
    private lazy var checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .mainColor
        imageView.contentMode = .scaleAspectFill
        if !isCheck {
            imageView.image = UIImage(systemName: "square")
        } else {
            imageView.image = UIImage(systemName: "checkmark.square")
        }
        return imageView
    }()
    
    func setupView(subject: Subject, cellHeight: CGFloat) {
        layout()
        setupTitleLabel(subject: subject, fontSize: cellHeight)
    }
    
    // 체크박스가 탭 되었을 때
    func didTapCheckBoxButton() {
        isCheck = !isCheck
        reloadCheckBoxButton(isCheck: isCheck)
    }
}

// MARK: - UI Methods
private extension SubjectPickerCollectionViewCell {
    func reloadCheckBoxButton(isCheck: Bool) {
        if !isCheck {
            checkBoxImageView.image = UIImage(systemName: "square")
        } else {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square")
        }
    }
    func setupTitleLabel(subject: Subject, fontSize: CGFloat) {
        titleLabel.text = subject.description
        titleLabel.font = .systemFont(ofSize: fontSize, weight: .regular)
    }
    func layout() {
        [
            titleLabel,
            checkBoxImageView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        checkBoxImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24.0)
        }
    }
}
