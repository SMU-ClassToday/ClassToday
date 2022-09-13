//
//  StarViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/20.
//

import UIKit
import SnapKit

class StarViewController: UIViewController {
    //MARK: - NavigationBar Components
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
    
    private lazy var nonDataAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 수업 아이템이 없어요"
        label.textColor = UIColor.systemGray
        return label
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
        classItemTableView.delegate = self
        classItemTableView.register(ClassItemTableViewCell.self, forCellReuseIdentifier: ClassItemTableViewCell.identifier)
        return classItemTableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: Properties

    private var data: [ClassItem] = []
    private let firestoreManager = FirestoreManager.shared

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
        starSort(starList: MockData.mockUser.stars ?? [""])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        starSort(starList: MockData.mockUser.stars ?? [""])
    }
    // MARK: - Method
    private func starSort(starList: [String]) {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.classItemTableView.refreshControl?.endRefreshing()
                guard let keywordLocation = user.keywordLocation else {
                    // 위치 설정 해야됨
                    return
                }
                self.firestoreManager.starSort(keyword: keywordLocation, starList: starList) { [weak self] data in
                    self?.data = data
                    DispatchQueue.main.async {
                        self?.classItemTableView.reloadData()
                    }
                }
                
            case .failure(let error):
                self.classItemTableView.refreshControl?.endRefreshing()
                print("ERROR \(error)🌔")
            }
        }
    }
}

//MARK: - objc methods
private extension StarViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func beginRefresh() {
        print("beginRefresh!")
        starSort(starList: MockData.mockUser.stars ?? [""])
        refreshControl.endRefreshing()
    }
}

//MARK: - Autolayout
private extension StarViewController {
    func layout() {
        [
            classItemTableView
        ].forEach { view.addSubview($0) }
        
        classItemTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        classItemTableView.addSubview(nonDataAlertLabel)
        nonDataAlertLabel.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
}

//MARK: - TableView DataSource
extension StarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty {
            nonDataAlertLabel.isHidden = false
        } else {
            nonDataAlertLabel.isHidden = true
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        let classItem = data[indexPath.row]
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

extension StarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classItem = data[indexPath.row]
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
