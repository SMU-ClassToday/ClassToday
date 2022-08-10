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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(Icon.star.image, for: .normal)
        button.setImage(Icon.fillStar.image, for: .selected)
        button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        let starItem = UIBarButtonItem(customView: button)
        return starItem
    }()
    
    private lazy var searchItem: UIBarButtonItem = {
        let searchItem = UIBarButtonItem.menuButton(self, action: #selector(didTapSearchButton), image: Icon.search.image)
        return searchItem
    }()
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        navigationItem.rightBarButtonItems = [starItem, searchItem]
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
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(16)
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

    private func fetchClassItem(location: Location) {
        FirestoreManager.shared.fetch(location) { [weak self] data in
            guard let self = self else { return }
            self.classItemData = data
        }
    }
}

//MARK: - objc function
extension MapViewController {
    /// 즐겨찾기 버튼
    @objc private func didTapStarButton(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            guard let location = curLocation else { return }
            fetchClassItem(location: location)
        } else {
            sender.isSelected = true
            FirestoreManager.shared.starSort(starList: MockData.mockUser.stars ?? [""]) {
                self.classItemData = $0
            }
        }
    }
    @objc private func didTapSearchButton(_ sender: UIButton) {
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
