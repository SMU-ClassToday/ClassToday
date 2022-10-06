//
//  ProfileUserInfoView.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit
import SnapKit

class ProfileUserInfoView: UIView {
    // MARK: - UI Components
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40.0
        return imageView
    }()
    private lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "male")
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    private lazy var disclosureIndicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.disclosureIndicator.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var desciptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    private lazy var totalCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var buyCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.tag = 1
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveToClassHistory(_:))
        )
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var sellCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.tag = 2
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveToClassHistory(_:))
        )
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var bookmarkCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.tag = 3
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveToClassHistory(_:))
        )
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var buyCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    private lazy var sellCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    private lazy var bookmarkCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    private lazy var buyLabel: UILabel = {
        let label = UILabel()
        label.text = "구매한 수업"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    private lazy var sellLabel: UILabel = {
        let label = UILabel()
        label.text = "판매한 수업"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "후기"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    // MARK: - Properties
    private let type: UserProfileType
    private let user: User
    private var match: [Match] = []
    private var purchasedItems: [String] = []
    private var soldItems: [String] = []
    
    // MARK: - Delegate
    weak var delegate: ProfileUserInfoViewDelegate?
    
    // MARK: - init
    init(user: User, type: UserProfileType) {
        self.type = type
        self.user = user
        super.init(frame: .zero)
        layout()
        setupView(user: user)
        fetchMatch()
        fetchMatchBuy()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchMatch() {
        FirestoreManager.shared.fetchMatch(userId: UserDefaultsManager.shared.isLogin()!) { [weak self] data in
            self?.match = data
            
            let sold = data.filter {
                $0.seller == UserDefaultsManager.shared.isLogin()
            }
            for match in sold {
                self?.soldItems.append(match.classItem)
            }
            
            self?.sellCountLabel.text = String(sold.count)
            self?.bookmarkCountLabel.text = String(data.count)
        }
    }
    
    private func fetchMatchBuy() {
        FirestoreManager.shared.fetchMatchBuy(userId: UserDefaultsManager.shared.isLogin()!) { [weak self] data in
            let purchased = data.filter {
                $0.buyer == UserDefaultsManager.shared.isLogin()
            }
            for match in purchased {
                self?.purchasedItems.append(match.classItem)
            }
            self?.buyCountLabel.text = String(purchased.count)
        }
    }
}

// MARK: - @objc Methods
private extension ProfileUserInfoView {
    @objc func moveToClassHistory(_ recognizer: UITapGestureRecognizer) {
        guard let tag = recognizer.view?.tag else { return }
        switch tag {
        case 1:
            print("buy")
            let classHistoryViewController = ClassHistoryViewController(classHistory: .buy, classItemsID: purchasedItems)
            delegate?.moveToViewController(viewController: classHistoryViewController)
        case 2:
            print("sell")
            let classHistoryViewController = ClassHistoryViewController(classHistory: .sell, classItemsID: soldItems)
            delegate?.moveToViewController(viewController: classHistoryViewController)
        case 3:
            print("후기")
            let reviewListViewController = ReviewListViewController()
            delegate?.moveToViewController(viewController: reviewListViewController)
        default:
            break
        }
    }
}

// MARK: - UI Methods
private extension ProfileUserInfoView {
    func setupView(user: User) {
        userNameLabel.text = user.nickName
        companyLabel.text = user.company
        locationLabel.text = user.detailLocation
        desciptionLabel.text = user.description
        
        user.thumbnailImage { [weak self] image in
            guard let image = image else {
                self?.userImageView.image = UIImage(named: "person")
                return
            }
            self?.userImageView.image = image
        }
    }
    func layout() {
        [
            buyCountLabel, buyLabel
        ].forEach { buyCountStackView.addArrangedSubview($0) }
        [
            sellCountLabel, sellLabel
        ].forEach { sellCountStackView.addArrangedSubview($0) }
        [
            bookmarkCountLabel, bookmarkLabel
        ].forEach { bookmarkCountStackView.addArrangedSubview($0) }
        
        [
            buyCountStackView, sellCountStackView, bookmarkCountStackView
        ].forEach { totalCountStackView.addArrangedSubview($0) }
        
        switch type {
        case .brief:
            [
                userImageView,
                genderImageView,
                userNameLabel,
                companyLabel,
                locationLabel,
                disclosureIndicatorImageView,
                totalCountStackView,
                separatorView
            ].forEach { addSubview($0) }
        case .detail:
            [
                userImageView,
                genderImageView,
                userNameLabel,
                companyLabel,
                locationLabel,
                desciptionLabel,
                totalCountStackView,
                separatorView
            ].forEach { addSubview($0) }
        }
        
        let commonInset: CGFloat = 16.0
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.leading.top.equalToSuperview().inset(commonInset)
        }
        genderImageView.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.leading.equalTo(companyLabel.snp.leading)
            $0.bottom.equalTo(userNameLabel.snp.bottom)
        }
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(genderImageView.snp.trailing).offset(4.0)
            $0.bottom.equalTo(companyLabel.snp.top).offset(-4.0)
            $0.trailing.equalTo(companyLabel.snp.trailing)
        }
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(companyLabel.snp.leading)
            $0.top.equalTo(companyLabel.snp.bottom).offset(4.0)
            $0.trailing.equalTo(companyLabel.snp.trailing)
        }
        switch type {
        case .brief:
            companyLabel.snp.makeConstraints {
                $0.centerY.equalTo(userImageView.snp.centerY)
                $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
            }
            disclosureIndicatorImageView.snp.makeConstraints {
                $0.width.equalTo(16.0)
                $0.height.equalTo(20.0)
                $0.centerY.equalTo(userImageView.snp.centerY)
                $0.leading.equalTo(companyLabel.snp.trailing).offset(commonInset)
                $0.trailing.equalToSuperview().inset(commonInset)
            }
            totalCountStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(commonInset)
                $0.top.equalTo(userImageView.snp.bottom).offset(commonInset)
            }
            separatorView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(totalCountStackView.snp.bottom).offset(commonInset)
                $0.height.equalTo(8.0)
                $0.bottom.equalToSuperview()
            }
        case .detail:
            companyLabel.snp.makeConstraints {
                $0.centerY.equalTo(userImageView.snp.centerY)
                $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
                $0.trailing.equalToSuperview().inset(commonInset)
            }
            desciptionLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(commonInset)
                $0.top.equalTo(userImageView.snp.bottom).offset(commonInset)
            }
            totalCountStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(commonInset)
                $0.top.equalTo(desciptionLabel.snp.bottom).offset(commonInset)
            }
            separatorView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(totalCountStackView.snp.bottom).offset(commonInset)
                $0.height.equalTo(8.0)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
