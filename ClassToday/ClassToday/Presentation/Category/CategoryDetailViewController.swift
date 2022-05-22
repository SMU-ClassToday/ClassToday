//
//  CategotyDetailViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/20.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var leftBarItem: UIBarButtonItem = {
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        return leftBarItem
    }()
    
    lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = Subject.korean.description
        navigationTitle.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return navigationTitle
    }()
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.titleView = navigationTitle
        navigationTitle.text = categoryItem?.description
    }
    
    //MARK: - UI Components
    
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

    private var datas: [ClassItem] = [MockData.classItem, MockData.classItem, MockData.classItem, MockData.classItem]
    private var data: [ClassItem] = []
    private var dataBuy: [ClassItem] = []
    private var dataSell: [ClassItem] = []
    private let firestoreManager = FirestoreManager.shared
    private var categoryItem: Subject?
    
    // MARK: Initialize

    init(categoryItem: Subject) {
        super.init(nibName: nil, bundle: nil)
        self.categoryItem = categoryItem
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
        categorySort(category: categoryItem?.caseName ?? "")
    }
    
    //MARK: - Methods
    private func categorySort(category: String) {
        firestoreManager.categorySort(category: category) { [weak self] data in
            guard let self = self else { return }
            self.data = data
            self.dataBuy = data.filter { $0.itemType == ClassItemType.buy }
            self.dataSell = data.filter { $0.itemType == ClassItemType.sell }
            self.classItemTableView.reloadData()
        }
    }
}

//MARK: - objc functions
private extension CategoryDetailViewController {
    @objc func didChangedSegmentControlValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("모두")
            classItemTableView.reloadData()
        case 1:
            print("구매글")
            classItemTableView.reloadData()
        case 2:
            print("판매글")
            classItemTableView.reloadData()
        default:
            break
        }
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func beginRefresh() {
        print("beginRefresh!")
        refreshControl.endRefreshing()
    }
}

//MARK: - set autolayout
private extension CategoryDetailViewController {
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

//MARK: - tableview datasource
extension CategoryDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return data.count
            case 1:
                return dataBuy.count
            case 2:
                return dataSell.count
            default:
                return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        let classItem: ClassItem
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                classItem = data[indexPath.row]
            case 1:
                classItem = dataBuy[indexPath.row]
            case 2:
                classItem = dataSell[indexPath.row]
            default:
                classItem = data[indexPath.row]
        }
        cell.configureWith(classItem: classItem)
        return cell
    }
}

// MARK: - TableViewDelegate

extension CategoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classItem: ClassItem
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                classItem = data[indexPath.row]
            case 1:
                classItem = dataBuy[indexPath.row]
            case 2:
                classItem = dataSell[indexPath.row]
            default:
                classItem = data[indexPath.row]
        }
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
