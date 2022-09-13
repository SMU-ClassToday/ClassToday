//
//  ClassHistoryViewController.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import UIKit

class ClassHistoryViewController: UIViewController {

    private lazy var classItemTableView: UITableView = {
        let classItemTableView = UITableView()
        classItemTableView.refreshControl = refreshControl
        classItemTableView.rowHeight = 150.0
        classItemTableView.dataSource = self
        classItemTableView.delegate = self
        classItemTableView.register(ClassItemTableViewCell.self, forCellReuseIdentifier: ClassItemTableViewCell.identifier)
        return classItemTableView
    }()
    
    private lazy var nonDataAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "내역이 없어요"
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .mainColor
        return refreshControl
    }()
    
    
    private let classHistory: ClassHistory
    private var firestoreManager = FirestoreManager.shared
    private var classItemsID: [String] = []
    private var classItems: [ClassItem] = []
    private var dispatchGroup = DispatchGroup()
    
    init(classHistory: ClassHistory, classItemsID: [String]?) {
        self.classHistory = classHistory
        self.classItemsID = classItemsID ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
        configureList()
    }
}

private extension ClassHistoryViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        switch classHistory {
        case .buy:
            navigationItem.title = "구매한 수업"
        case .sell:
            navigationItem.title = "판매한 수업"
        }
    }
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    private func layout() {
        view.addSubview(classItemTableView)
        classItemTableView.addSubview(nonDataAlertLabel)
        classItemTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        nonDataAlertLabel.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    private func configureList() {
        guard classItemsID.isEmpty == false else {
            return
        }
        classItemTableView.refreshControl?.beginRefreshing()
        classItemsID.forEach { id in
            dispatchGroup.enter()
            firestoreManager.fetch(classItemID: id) { [weak self] classItem in
                self?.classItems.append(classItem)
                self?.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.classItemTableView.refreshControl?.endRefreshing()
            self?.classItemTableView.reloadData()
        }
    }
}

//MARK: - TableView datasource
extension ClassHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard classItems.isEmpty == false else {
            nonDataAlertLabel.isHidden = false
            return 0
        }
        nonDataAlertLabel.isHidden = true
        return classItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        let classItem = classItems[indexPath.row]
        cell.configureWith(classItem: classItem) { image in
            DispatchQueue.main.async {
                if indexPath == tableView.indexPath(for: cell) {
                    cell.thumbnailView.image = image
                }
            }
        }
        return cell
    }
}

//MARK: - TableView Delegate
extension ClassHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classItem = classItems[indexPath.row]
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
