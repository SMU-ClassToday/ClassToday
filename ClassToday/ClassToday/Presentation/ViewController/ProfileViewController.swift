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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let optionIndex = indexPath.row - 1
        switch indexPath.row {
        case 0:
            let viewController = ProfileDetailViewController(user: User.mockUser)
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
        switch indexPath.row {
        case 0:
            let cell = ProfileUserInfoTableViewCell(
                user: User.mockUser,
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
            cell.setupView(option: option.text)
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - ProfileUserInfoViewDelegate
extension ProfileViewController: ProfileUserInfoViewDelegate {
    func moveToClassHistoryViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - @objc Methods
private extension ProfileViewController {
    @objc func beginRefresh() {
        refreshControl.endRefreshing()
    }
}

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