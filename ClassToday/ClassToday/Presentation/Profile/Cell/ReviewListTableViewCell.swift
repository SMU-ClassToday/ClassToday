//
//  ReviewListTableViewCell.swift
//  ClassToday
//
//  Created by yc on 2022/05/03.
//

import UIKit
import SnapKit

class ReviewListTableViewCell: UITableViewCell {
    static let identifier = "ReviewListTableViewCell"
    
    // MARK: - UI Components
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30.0
        return imageView
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "옥냥이"
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    private lazy var locationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 노원구 상계1동 | 1분 전"
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "친절하게 가르쳐주셔서 감사합니다!! 친절하게 가르쳐주셔서 감사합니다!!"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    private lazy var disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.disclosureIndicator.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private var buyer: User?
    // MARK: - setup
    func setupView(match: Match) {
        layout()
        contentLabel.text = match.review?.description
        FirestoreManager.shared.readUser(uid: match.buyer) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.buyer = user
                self.userNameLabel.text = user.nickName
                self.locationDateLabel.text = user.detailLocation
                user.thumbnailImage { [weak self] image in
                    guard let image = image else {
                        self?.userImageView.image = UIImage(named: "person")
                        return
                    }
                    self?.userImageView.image = image
                }
            case .failure(_):
                print("getbuyer fail")
            }
        }
    }
}

// MARK: - UI Methods
private extension ReviewListTableViewCell {
    func layout() {
        [
            userNameLabel,
            locationDateLabel,
            contentLabel
        ].forEach { labelStackView.addArrangedSubview($0) }
        
        [
            userImageView,
            labelStackView,
            disclosureIndicator
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonInset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60.0)
        }
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
            $0.top.bottom.equalToSuperview().inset(commonInset)
        }
        disclosureIndicator.snp.makeConstraints {
            $0.leading.equalTo(labelStackView.snp.trailing).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16.0)
            $0.height.equalTo(20.0)
        }
    }
}
