//
//  SettingViewController.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    // MARK: - UI Components
    private lazy var settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(
            OptionTableViewCell.self,
            forCellReuseIdentifier: OptionTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Properties
    private let settingOptions: [Setting] = Setting.allCases
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return settingOptions.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OptionTableViewCell.identifier,
            for: indexPath
        ) as? OptionTableViewCell else { return UITableViewCell() }
        let option = settingOptions[indexPath.row]
        cell.setupView(option: option.text)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UI Methods
private extension SettingViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.title = "설정"
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}