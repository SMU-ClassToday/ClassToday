//
//  ReviewDetailViewController.swift
//  ClassToday
//
//  Created by yc on 2022/05/04.
//

import UIKit
import SnapKit

class ReviewDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var contentView = UIView()
    private lazy var classThumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4.0
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    private lazy var classTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "6월 수학 가형 모고풀이"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var classLocationAndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "노원구 중계1동 | 하루 전"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var classPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "20,000원"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var classLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "person")
        imageView.layer.cornerRadius = 40.0
        return imageView
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "옥냥이"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var userLocationAndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 노원구 중계1동 | 1분 전"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var userLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    private lazy var gradeStarView = GradeStarView(grade: 2.7129)
    private lazy var contentLabelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 4.0
        return view
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "친절하게 가르쳐주셔서 감사합니다!!친절하게 가르쳐주셔서 감사합니다!!"
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let match: Match
    private let seller: User
    private let classItem: ClassItem
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        configure()
        layout()
    }
    
    init(match: Match, seller: User, classItem: ClassItem) {
        self.match = match
        self.seller = seller
        self.classItem = classItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Methods
private extension ReviewDetailViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func configure() {
        userNameLabel.text = seller.nickName
        contentLabel.text = match.review?.description
    }
    func layout() {
        
        [
            classTitleLabel,
            classLocationAndDateLabel,
            classPriceLabel,
        ].forEach { classLabelStackView.addArrangedSubview($0) }
        [
            userNameLabel,
            userLocationAndDateLabel
        ].forEach { userLabelStackView.addArrangedSubview($0) }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        contentLabelBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8.0)
        }
        
        [
            classThumbnailView,
            classLabelStackView,
            userImageView,
            userLabelStackView,
            gradeStarView,
            contentLabelBackgroundView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        classThumbnailView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(commonInset)
            $0.size.equalTo(80.0)
        }
        classLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(classThumbnailView.snp.trailing).offset(commonInset)
            $0.centerY.equalTo(classThumbnailView.snp.centerY)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        userImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.leading.equalToSuperview().inset(commonInset)
            $0.top.equalTo(classThumbnailView.snp.bottom).offset(commonInset)
        }
        userLabelStackView.snp.makeConstraints {
            $0.centerY.equalTo(userImageView.snp.centerY)
            $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        gradeStarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(userImageView.snp.bottom).offset(commonInset)
        }
        contentLabelBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(gradeStarView.snp.bottom).offset(commonInset)
            $0.bottom.equalToSuperview()
        }
    }
}
