//
//  GradeUserInfoTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class GradeUserInfoTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "강사 평점"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var gradeStarView = GradeStarView(grade: 0.0)
    
    func setupView(grade: Double) {
        layout()
        gradeStarView.updateStars(grade: grade)
    }
}

private extension GradeUserInfoTableViewCell {
    func layout() {
        [
            titleLabel,
            gradeStarView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        gradeStarView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
