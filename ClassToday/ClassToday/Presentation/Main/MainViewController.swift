//
//  MainViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit


class MainViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var leftTitle: UILabel = {
        let leftTitle = UILabel()
        leftTitle.text = "서울시 노원구의 수업"
        leftTitle.textColor = .black
        leftTitle.font = .systemFont(ofSize: 20.0, weight: .bold)
        return leftTitle
    }()

    private lazy var starItem: UIBarButtonItem = {
        let starItem = UIBarButtonItem.menuButton(self, action: #selector(didTapStarButton), image: Icon.star.image)
        return starItem
    }()

    private lazy var categoryItem: UIBarButtonItem = {
        let categoryItem = UIBarButtonItem.menuButton(self, action: #selector(didTapCategoryButton), image: Icon.category.image)
        return categoryItem
    }()

    private lazy var searchItem: UIBarButtonItem = {
        let searchItem = UIBarButtonItem.menuButton(self, action: #selector(didTapSearchButton), image: Icon.search.image)
        return searchItem
    }()

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        navigationItem.rightBarButtonItems = [starItem, searchItem, categoryItem]
    }

    //MARK: - Main View의 UI Components
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "모두", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "구매글", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "판매글", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangedSegmentControlValue(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
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

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        layout()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    // MARK: - Method
    private func fetchData() {
        firestoreManager.fetch { [weak self] data in
            guard let self = self else { return }
            self.data = data
            self.classItemTableView.reloadData()
        }
    }
}

//MARK: - gesture delegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: - objc functions
private extension MainViewController {
    @objc func didChangedSegmentControlValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("모두")
        case 1:
            print("구매글")
        case 2:
            print("판매글")
        default:
            break
        }
    }

    @objc func beginRefresh() {
        print("beginRefresh!")
        fetchData()
        refreshControl.endRefreshing()
    }

    @objc func didTapStarButton() {
        let starViewController = StarViewController()
        navigationController?.pushViewController(starViewController, animated: true)
    }

    @objc func didTapCategoryButton() {
        let categoryListViewController = CategoryListViewController()
        navigationController?.pushViewController(categoryListViewController, animated: true)
    }

    @objc func didTapSearchButton() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

private extension MainViewController {
    //MARK: - set autolayout
    func layout() {
        [
            segmentedControl,
            classItemTableView
        ].forEach { view.addSubview($0) }
        
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        classItemTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - TableView datasource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        let classItem = data[indexPath.row]
        cell.configureWith(classItem: classItem)
        return cell
    }
}

//MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classItem = data[indexPath.row]
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
