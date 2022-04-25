//
//  StarViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/20.
//

import UIKit
import SnapKit

class StarViewController: UIViewController {
    //MARK: NavigationBar Components
    private lazy var leftBarItem: UIBarButtonItem = {
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        return leftBarItem
    }()
    
    private lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "즐겨찾기"
        navigationTitle.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return navigationTitle
    }()
    
    private lazy var rightBarItem: UIBarButtonItem = {
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: nil, action: nil)
        return rightBarItem
    }()
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.titleView = navigationTitle
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    //MARK: TableView
    private lazy var classItemTableView: UITableView = {
        let classItemTableView = UITableView()
        classItemTableView.refreshControl = refreshControl
        classItemTableView.rowHeight = 150.0
        classItemTableView.dataSource = self
        classItemTableView.register(ClassItemTableViewCell.self, forCellReuseIdentifier: ClassItemTableViewCell.identifier)
        return classItemTableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
    }
}

private extension StarViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func beginRefresh() {
        print("beginRefresh!")
        refreshControl.endRefreshing()
    }
}

private extension StarViewController {
    func layout() {
        [
            classItemTableView
        ].forEach { view.addSubview($0) }
        
        classItemTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension StarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        cell.setupView()
        return cell
    }
}
