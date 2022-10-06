//
//  MapViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/26.
//

import UIKit
import NMapsMap
import XCTest

class MapViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var leftTitle: UILabel = {
        let leftTitle = UILabel()
        leftTitle.textColor = .black
        leftTitle.sizeToFit()
        leftTitle.text = "우리동네 클래스 스팟"
        leftTitle.font = .systemFont(ofSize: 20.0, weight: .bold)
        return leftTitle
    }()
    
    private lazy var starItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(Icon.star.image, for: .normal)
        button.setImage(Icon.fillStar.image, for: .selected)
        button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        let starItem = UIBarButtonItem(customView: button)
        return starItem
    }()
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        navigationItem.rightBarButtonItems = [starItem]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    //MARK: - Views
    private lazy var categoryView: MapCategoryView = {
        let categoryView = MapCategoryView(frame: .zero)
        categoryView.categoryCollectionView.dataSource = self
        categoryView.categoryCollectionView.delegate = self
        categoryView.delegate = self
        return categoryView
    }()
    
    private lazy var mapView: MapView = {
        let mapView = MapView()
        return mapView
    }()

    private lazy var mapClassListView: MapClassListView = {
        let mapClassListView = MapClassListView()
        mapClassListView.delegate = self
        return mapClassListView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    //MARK: - Properties
    private var curLocation: Location? {
        return LocationManager.shared.getCurrentLocation()
    }
    private var curKeyword: String?
    private var delegate: MapCategorySelectViewControllerDelegate?
    private var categoryData: [CategoryItem] = [] {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.categoryView.setPlaceHolderLabel(newValue.isEmpty)
            }
        }
    }
    private var classItemData: [ClassItem] = [] {
        willSet {
            mapView.removeMarkers()
            var localDatas: [ClassItem] = []
            newValue.forEach {
                if $0.keywordLocation == curKeyword {
                    localDatas.append($0)
                }
            }
            localDatas.sort { $0 > $1 }
            print(localDatas)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureMapView(data: newValue)
                self.mapClassListView.configure(with: localDatas)
            }
        }
    }
    private var currentUser: User?
    private var currentLocation: String?
    private var naverMapAPIProvider = NaverMapAPIProvider()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.currentUser = user
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let location = curLocation else {
            debugPrint("위치를 읽어올 수 없습니다.")
            return
        }
        setupMapView(location: location)
        DispatchQueue.global().sync {
            naverMapAPIProvider.locationToKeyword(location: location) { [weak self] result in
                switch result {
                case .success(let keyword):
                    self?.curKeyword = keyword
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
        if categoryData.isEmpty {
            fetchClassItem()
        }
    }
    
    //MARK: - Methods
    private func setupLayout() {
        view.addSubview(categoryView)
        view.addSubview(scrollView)
        categoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        scrollView.addSubview(mapView)
        scrollView.addSubview(mapClassListView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        mapClassListView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom)
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(50)
            $0.width.equalToSuperview()
        }
    }

    private func setupMapView(location: Location) {
        mapView.setUpLocation(location: location)
    }

    private func configureMapView(data: [ClassItem]) {
        mapView.removeMarkers()
        data.forEach {
            mapView.configureClassItemMarker(classItem: $0) {
                self.navigationController?.pushViewController(ClassDetailViewController(classItem: $0), animated: true)
            }
        }
    }

    private func fetchClassItem() {
        FirestoreManager.shared.fetch { [weak self] data in
            self?.classItemData = data
        }
    }
}

//MARK: - objc function
extension MapViewController {
    /// 즐겨찾기 버튼
    @objc private func didTapStarButton(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            fetchClassItem()
        } else {
            sender.isSelected = true
            guard let list = currentUser?.stars, list.isEmpty == false else {
                classItemData = []
                return
            }
            FirestoreManager.shared.starSort(starList: list) { [weak self] in
                self?.classItemData = $0
            }
        }
    }
}

// MARK: - CollectionViewDataSource

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailContentCategoryCollectionViewCell.identifier,
            for: indexPath) as? DetailContentCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureWith(category: categoryData[indexPath.item])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontsize = categoryData[indexPath.item].description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let width = fontsize.width
        let height = fontsize.height
        return CGSize(width: width + 24, height: height)
    }
}

extension MapViewController: MapCategoryViewDelegate {
    func pushCategorySelectViewController() {
        let vc = MapCategorySelectViewController()
        vc.delegate = self
        let selectedCategory = categoryData.map { $0 as? Subject }.compactMap { $0 }
        vc.configure(with: Set(selectedCategory))
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 카테고리 선택 시 호출
extension MapViewController: MapCategorySelectViewControllerDelegate {
    func passData(subjects: Set<Subject>) {
        categoryData = Array(subjects)
        guard !categoryData.isEmpty else {
            fetchClassItem()
            return
        }
        FirestoreManager.shared.categorySort(categories: self.categoryData
            .map{$0 as? Subject}
            .compactMap{$0}
            .map{$0.rawValue}
        ){ [weak self] data in
            guard let self = self else { return }
            self.classItemData = data
        }
    }
}

extension MapViewController: MapClassListViewDelegate {
    func presentViewController(with classItem: ClassItem) {
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
