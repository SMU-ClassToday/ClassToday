//
//  MainViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit

protocol MainViewControllerLocationDelegate: AnyObject {
    func checkLocationAuthority()
}

class MainViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var leftTitle: UILabel = {
        let leftTitle = UILabel()
        leftTitle.textColor = .black
        leftTitle.sizeToFit()
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
    
    private lazy var nonAuthorizationAlertLabel: UILabel = {
        let label = UILabel()
        label.text = "위치정보 권한을 허용해주세요."
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
        refreshControl.tintColor = .mainColor
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Properties
    private var data: [ClassItem] = []
    private var dataBuy: [ClassItem] = []
    private var dataSell: [ClassItem] = []
    private let firestoreManager = FirestoreManager.shared
    private let locationManager = LocationManager.shared
    private let provider = NaverMapAPIProvider()
    private let dispatchGroup: DispatchGroup = DispatchGroup()
    weak var delegate: MainViewControllerLocationDelegate?

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        layout()
        locationManager.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = requestLocationAuthorization()
    }

    // MARK: - Method
    /// 현재 기기의 위치를 기준으로 수업 아이템을 패칭합니다.
    ///
    /// - 패칭 기준: Location의 KeywordLocation 값 ("@@구")
    private func fetchData() {
        classItemTableView.refreshControl?.beginRefreshing()
        nonDataAlertLabel.isHidden = true
        guard let currentLocation = locationManager.getCurrentLocation() else { return }
        firestoreManager.fetch(currentLocation) { [weak self] data in
            self?.data = data
            self?.dataBuy = data.filter { $0.itemType == ClassItemType.buy }
            self?.dataSell = data.filter { $0.itemType == ClassItemType.sell }
            DispatchQueue.main.async {
                self?.classItemTableView.reloadData()
                self?.classItemTableView.refreshControl?.endRefreshing()
            }
        }
    }
    /// 현재 기기의 위치를 주소명으로 패칭하여 상단에 표시합니다.
    ///
    ///  - 출력 형태: "@@시 @@구의 수업"
    private func configureLocation() {
        print("Location was fetched and Now Address Fetching")
        guard let location = locationManager.getCurrentLocation() else { return }
        provider.locationToKeywordAddress(location: location) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.leftTitle.text = result + "의 수업"
                self.leftTitle.frame.size = self.leftTitle.intrinsicContentSize
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

    @objc func beginRefresh() {
        print("beginRefresh!")
        if requestLocationAuthorization() {
            return
        }
        fetchData()
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
            classItemTableView,
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

//MARK: - TableView datasource
extension MainViewController: UITableViewDataSource {
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

//MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate {
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

//MARK: - LocationManagerDelegate
extension MainViewController: LocationManagerDelegate {
    /// 위치정보가 갱신되면 호출됩니다. 보통 권한이 허용될때 최초 호출됩니다.
    ///
    /// - 주소명과 수업 아이템을 패칭합니다.
    func didUpdateLocation() {
        configureLocation()
        fetchData()
    }

    /// 위치정보권한 상태 변경에 따른 경고 레이블 처리
    ///
    /// - denied, restricted의 경우 경고 레이블 표시
    /// - allowed, not determined의 경우 경고 레이블 미표시
    func didUpdateAuthorization() {
        if locationManager.isLocationAuthorizationAllowed() {
            nonAuthorizationAlertLabel.isHidden = true
        } else {
            nonAuthorizationAlertLabel.isHidden = false
        }
    }
}
