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
        navigationTitle.font = .systemFont(ofSize: 18.0, weight: .semibold)
        navigationTitle.textColor = .black
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

    private lazy var nonAuthorizationAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "위치정보 권한을 허용해주세요."
        label.isHidden = true
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private lazy var nonDataAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 수업 아이템이 없어요"
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        refreshControl.tintColor = .mainColor
        return refreshControl
    }()
    
    // MARK: Properties

    private var data: [ClassItem] = []
    private var dataBuy: [ClassItem] = []
    private var dataSell: [ClassItem] = []
    private let firestoreManager = FirestoreManager.shared
    private let locationManager = LocationManager.shared
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
        view.backgroundColor = .white
        setNavigationBar()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !requestLocationAuthorization() {
            categorySort()
        }
    }
    
    //MARK: - Methods
    private func categorySort() {
        classItemTableView.refreshControl?.beginRefreshing()
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.classItemTableView.refreshControl?.endRefreshing()
                guard let keywordLocation = user.keywordLocation else {
                    // 위치 설정 해야됨
                    return
                }
                self.firestoreManager.categorySort(keyword: keywordLocation, category: self.categoryItem?.rawValue ?? "") { [weak self] data in
                    guard let self = self else { return }
                    self.data = data
                    self.dataBuy = data.filter { $0.itemType == ClassItemType.buy }
                    self.dataSell = data.filter { $0.itemType == ClassItemType.sell }
                    DispatchQueue.main.async { [weak self] in
                        self?.classItemTableView.refreshControl?.endRefreshing()
                        self?.classItemTableView.reloadData()
                    }
                }
                
            case .failure(let error):
                self.classItemTableView.refreshControl?.endRefreshing()
                print("ERROR \(error)🌔")
            }
        }
    }
    
    /// 위치권한상태를 확인하고, 필요한 경우 얼럿을 호출합니다.
    ///
    /// - return 값: true - 권한요청, false - 권한허용
    private func requestLocationAuthorization() -> Bool {
        if !locationManager.isLocationAuthorizationAllowed() {
            nonAuthorizationAlertLabel.isHidden = false
            present(UIAlertController.locationAlert(), animated: true) {
                self.refreshControl.endRefreshing()
            }
            return true
        }
        nonAuthorizationAlertLabel.isHidden = true
        return false
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
        categorySort()
    }
}

//MARK: - set autolayout
private extension CategoryDetailViewController {
    func layout() {
        [
            segmentedControl,
            classItemTableView
        ].forEach { view.addSubview($0) }
        [
            nonAuthorizationAlertLabel,
            nonDataAlertLabel
        ].forEach { classItemTableView.addSubview($0) }
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        classItemTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        nonAuthorizationAlertLabel.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        nonDataAlertLabel.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
}

//MARK: - tableview datasource
extension CategoryDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                count = data.count
            case 1:
                count = dataBuy.count
            case 2:
                count = dataSell.count
            default:
                count = data.count
        }
        
        guard nonAuthorizationAlertLabel.isHidden else {
            nonDataAlertLabel.isHidden = true
            return count
        }
        if count == 0 {
            nonDataAlertLabel.isHidden = false
        } else {
            nonDataAlertLabel.isHidden = true
        }
        return count
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
