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
    private lazy var gradeStarView = GradeStarView(grade: 3.141592)
    private lazy var reviewListCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 \(reviewList.count)건"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        return label
    }()
    private lazy var reviewListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            ReviewListTableViewCell.self,
            forCellReuseIdentifier: ReviewListTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Properties
    var reviewList: [Match] = []
    var buyer: User?
    var classItem: ClassItem?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        fetchMatch()
        layout()
    }

    private func fetchMatch() {
        FirestoreManager.shared.fetchMatch(userId: UserDefaultsManager.shared.isLogin()!) { [weak self] data in
            self?.reviewList = data
            self?.reviewListCountLabel.text = "총 \(data.count)건"
            self?.reviewListTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension ReviewListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FirestoreManager.shared.fetch(classItemId: reviewList[indexPath.row].classItem) { [weak self] result in
            switch result {
            case .success(let classItem):
                self?.classItem = classItem
                FirestoreManager.shared.readUser(uid: self!.reviewList[indexPath.row].buyer) { [weak self] result in
                    switch result {
                    case .success(let user):
                        self?.buyer = user
                        let reviewDetailViewController = ReviewDetailViewController(match: self!.reviewList[indexPath.row], buyer: self!.buyer!, classItem: self!.classItem!)
                        self?.navigationController?.pushViewController(reviewDetailViewController, animated: true)
                    case .failure(_):
                        print("fetchbuyer fail")
                    }
                }
            case .failure(_):
                print("fetchClassItem Fail")
            }
        }
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
        cell.setupView(match: reviewList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UI Methods
private extension ReviewListViewController {
    func setupNavigationBar() {
        navigationItem.title = "후기"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            titleLabel,
            gradeStarView,
            reviewListCountLabel,
            reviewListTableView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        gradeStarView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
        }
        reviewListCountLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.top.equalTo(gradeStarView.snp.bottom).offset(commonInset)
        }
        reviewListTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(reviewListCountLabel.snp.bottom).offset(commonInset)
        }
    }
}
