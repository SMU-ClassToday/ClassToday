//
//  MapViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/26.
//

import UIKit
import NMapsMap

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
        let starItem = UIBarButtonItem.menuButton(self, action: #selector(didTapStarButton), image: Icon.star.image)
        return starItem
    }()
    
    private lazy var searchItem: UIBarButtonItem = {
        let searchItem = UIBarButtonItem.menuButton(self, action: #selector(didTapSearchButton), image: Icon.search.image)
        return searchItem
    }()
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        navigationItem.rightBarButtonItems = [starItem, searchItem]
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
        return scrollView
    }()

    //MARK: - Properties
    private var curLocation: Location? {
        return LocationManager.shared.getCurrentLocation()
    }
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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureMapView(data: newValue)
                self.mapClassListView.configure(with: newValue)
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let location = curLocation else {
            return
        }
        setupMapView(location: location)
        if categoryData.isEmpty {
            fetchClassItem(location: location)
        }
    }
    
    //MARK: - Methods
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        scrollView.addSubview(categoryView)
        scrollView.addSubview(mapView)
        scrollView.addSubview(mapClassListView)
        categoryView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        mapView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.top.equalTo(categoryView)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.height).multipliedBy(0.5)
        }
        mapClassListView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.top.equalTo(mapView)
            $0.leading.trailing.equalToSuperview()
        }
    }

    private func setupMapView(location: Location) {
        mapView.setUpLocation(location: location)
    }

    private func configureMapView(data: [ClassItem]) {
        mapView.removeMarkers()
        data.forEach {
            mapView.configureClassItemMarker(classItem: $0) {
                self.navigationController?.present(ClassDetailViewController(classItem: $0), animated: true)
            }
        }
    }

    private func fetchClassItem(location: Location) {
        FirestoreManager.shared.fetch(location) { [weak self] data in
            guard let self = self else { return }
            self.classItemData = data
        }
    }
}

//MARK: - objc function
extension MapViewController {
    @objc private func didTapStarButton(sender: UIButton) {
        FirestoreManager.shared.starSort(starList: MockData.mockUser.stars ?? [""]) {
            self.classItemData = $0
        }
    }
    @objc private func didTapSearchButton(sender: UIButton) {
        // 검색 뷰 컨트롤러를 활용할 방법?
        navigationController?.pushViewController(SearchViewController(), animated: true)
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
        guard let curLocation = curLocation, !categoryData.isEmpty else {
            FirestoreManager.shared.fetch(curLocation) { [weak self] data in
                guard let self = self else { return }
                self.classItemData = data
            }
            return
        }

        FirestoreManager.shared.categorySort(location: curLocation, categories: categoryData.map{$0 as? Subject}.compactMap{$0}.map{$0.rawValue}) { [weak self] data in
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
