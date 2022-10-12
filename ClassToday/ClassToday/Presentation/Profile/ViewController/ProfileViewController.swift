//
//  ProfileViewController.swift
//  Practice
//
//  Created by yc on 2022/04/17.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
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
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 500.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            OptionTableViewCell.self,
            forCellReuseIdentifier: OptionTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Properties
    private let options: [Option] = Option.allCases
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private var currentUser: User?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
                self.profileTableView.reloadData()
            case .failure(let error):
                print("ERROR \(error)🌔")
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let currentUser = currentUser else { return }
        let optionIndex = indexPath.row - 1
        switch indexPath.row {
        case 0:
            let viewController = ProfileDetailViewController(user: currentUser)
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        case 1...6:
            let viewController = options[optionIndex].viewController
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return options.count + 1
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let currentUser = currentUser else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let cell = ProfileUserInfoTableViewCell(
                user: currentUser,
                type: .brief
            )
            cell.setupView()
            cell.infoView.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OptionTableViewCell.identifier,
                for: indexPath
            ) as? OptionTableViewCell else { return UITableViewCell() }
            
            let option = options[indexPath.row - 1]
            cell.setupView(element: option)
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - ProfileUserInfoViewDelegate
extension ProfileViewController: ProfileUserInfoViewDelegate {
    func moveToViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ProfileDetailViewControllerDelegate
extension ProfileViewController: ProfileDetailViewControllerDelegate {
    func didFinishUpdateUserInfo() {
        beginRefresh()
    }
}

// MARK: - @objc Methods
private extension ProfileViewController {
    @objc func beginRefresh() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
                self.profileTableView.reloadData()
            case .failure(let error):
                print("ERROR \(error)🌔")
            }
        }
        refreshControl.endRefreshing()
    }
}

// MARK: - Methods
private extension ProfileViewController {}

// MARK: - UI Methods
private extension ProfileViewController {
    func setupNavigationBar() {
        navigationItem.setLeftTitle(text: "나의 프로필")
        navigationController?.navigationBar.tintColor = .mainColor
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        view.addSubview(profileTableView)
        
        profileTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
