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
    private lazy var starImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        return stackView
    }()
    
    func setupView() {
        layout()
    }
}

private extension GradeUserInfoTableViewCell {
    func layout() {
        [
            starImageView1,
            starImageView2,
            starImageView3,
            starImageView4,
            starImageView5
        ].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(36.0)
            }
            starImageStackView.addArrangedSubview(button)
        }
        [
            titleLabel,
            starImageStackView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        starImageStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
