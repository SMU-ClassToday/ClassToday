//
//  ProfileDetailViewController.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit
import SnapKit
import CoreMedia

class ProfileDetailViewController: UIViewController {
    // MARK: - UI Components
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(beginRefresh),
            for: .valueChanged
        )
        return refreshControl
    }()
    private lazy var userInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 500.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Properties
    let user: User
    
    // MARK: - init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UITableViewDataSource
extension ProfileDetailViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 5
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = ProfileUserInfoTableViewCell(user: user, type: .detail)
            cell.infoView.delegate = self
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = GradeUserInfoTableViewCell()
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = SubjectUserInfoTableViewCell(user: user)
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = BuyUserInfoTableViewCell()
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = SellUserInfoTableViewCell()
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - ProfileUserInfoViewDelegate
extension ProfileDetailViewController: ProfileUserInfoViewDelegate {
    func moveToViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - @objc Methods
private extension ProfileDetailViewController {
    @objc func beginRefresh() {
        refreshControl.endRefreshing()
    }
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
        let rootViewController = ProfileModifyViewController(user: user)
        let profileModifyViewController = UINavigationController(rootViewController: rootViewController)
        profileModifyViewController.modalPresentationStyle = .fullScreen
        present(profileModifyViewController, animated: true)
    }
}

// MARK: - UI Methods
private extension ProfileDetailViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        // 본인 프로필 상세 뷰로 들어갈 때, 다른 사람의 프로필 상세 뷰로 들어갈 때
        if user == MockData.mockUser {
            navigationItem.title = "나의 프로필"
            let rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "pencil"),
                style: .plain,
                target: self,
                action: #selector(didTapRightBarButton)
            )
            navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            let chatButton = UIButton()
            let infoButton = UIButton()
            chatButton.setImage(UIImage(systemName: "message"), for: .normal)
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            [
                chatButton,
                infoButton
            ].forEach { button in
                button.snp.makeConstraints { $0.size.equalTo(24.0) }
            }
            let chatBarButtonItem = UIBarButtonItem(customView: chatButton)
            let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
            navigationItem.rightBarButtonItems = [infoBarButtonItem, chatBarButtonItem]
        }
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        view.addSubview(userInfoTableView)
        
        userInfoTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
