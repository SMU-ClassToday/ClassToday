//
//  ReviewListViewController.swift
//  ClassToday
//
//  Created by yc on 2022/05/03.
//

import UIKit
import SnapKit

class ReviewListViewController: UIViewController {
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.bigFontSize(
            text: "예스코치님의 평균 별점",
            bigText: "예스코치",
            fontSize: 18.0,
            bigFontSize: 32.0,
            weight: .medium,
            bigWeight: .semibold
        )
        return label
    }()
    private lazy var starImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var starImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
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
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "3.25"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    private lazy var reviewListCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 \(reviewList.count)건"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        return label
    }()
    private lazy var reviewListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(
            ReviewListTableViewCell.self,
            forCellReuseIdentifier: ReviewListTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Properties
    var reviewList = [1, 2, 3, 4, 5] // [Review]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UITableViewDataSource
extension ReviewListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReviewListTableViewCell.identifier,
            for: indexPath
        ) as? ReviewListTableViewCell else { return UITableViewCell() }
        cell.setupView()
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UI Methods
private extension ReviewListViewController {
    func setupNavigationBar() {
        navigationItem.title = "후기"
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            starImageView1,
            starImageView2,
            starImageView3,
            starImageView4,
            starImageView5
        ].forEach { star in
            star.snp.makeConstraints {
                $0.size.equalTo(36.0)
            }
            starImageStackView.addArrangedSubview(star)
        }
        
        [
            titleLabel,
            starImageStackView,
            scoreLabel,
            reviewListCountLabel,
            reviewListTableView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        starImageStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
        }
        scoreLabel.snp.makeConstraints {
            $0.leading.equalTo(starImageStackView.snp.trailing).offset(commonInset)
            $0.bottom.equalTo(starImageStackView.snp.bottom)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        reviewListCountLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.top.equalTo(starImageStackView.snp.bottom).offset(commonInset)
        }
        reviewListTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(reviewListCountLabel.snp.bottom).offset(commonInset)
        }
    }
}
