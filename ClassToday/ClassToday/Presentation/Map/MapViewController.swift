//
//  MapViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/26.
//

import UIKit
import NMapsMap
import SwiftUI

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
    
    private lazy var mapView: NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        let mapView = naverMapView.mapView
        mapView.mapType = NMFMapType.basic
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        mapView.positionMode = NMFMyPositionMode.direction
        return naverMapView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var mapClassListView: MapClassListView = {
        let mapClassListView = MapClassListView()
        mapClassListView.delegate = self
        return mapClassListView
    }()
    
    //MARK: - Properties
    private var curLocation: Location? {
        return LocationManager.shared.getCurrentLocation()
    }
    private var delegate: MapCategorySelectViewControllerDelegate?
    private var data: [CategoryItem] = [] {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.categoryView.setPlaceHolderLabel(newValue.isEmpty)
            }
        }
    }
    private var classItemData: [ClassItem] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        FirestoreManager.shared.fetch(curLocation) { [weak self] data in
            guard let self = self else { return }
            self.classItemData = data
            self.mapClassListView.configure(with: data)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let location = curLocation else {
            return
        }
        setupMapView(location: location)
    }
    
    //MARK: - Methods
    private func setupLayout() {
        view.addSubview(categoryView)
        view.addSubview(mapView)
        view.addSubview(mapClassListView)
        categoryView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        mapClassListView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setupMapView(location: Location) {
        let coord = NMGLatLng(lat: location.lat, lng: location.lon)
        mapView.mapView.latitude = coord.lat
        mapView.mapView.longitude = coord.lng
    }
}

//MARK: - objc function
extension MapViewController {
    @objc private func didTapStarButton(sender: UIButton) {
        
    }
    @objc private func didTapSearchButton(sender: UIButton) {
        
    }
}

// MARK: - CollectionViewDataSource

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailContentCategoryCollectionViewCell.identifier,
            for: indexPath) as? DetailContentCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureWith(category: data[indexPath.item])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontsize = data[indexPath.item].description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let width = fontsize.width
        let height = fontsize.height
        return CGSize(width: width + 24, height: height)
    }
}

extension MapViewController: MapCategoryViewDelegate {
    func pushCategorySelectViewController() {
        let vc = MapCategorySelectViewController()
        vc.delegate = self
        let selectedCategory = data.map { $0 as? Subject }.compactMap { $0 }
        vc.configure(with: Set(selectedCategory))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MapViewController: MapCategorySelectViewControllerDelegate {
    func passData(subjects: Set<Subject>) {
        data = Array(subjects)
    }
}

extension MapViewController: MapClassListViewDelegate {
    func presentViewController(with classItem: ClassItem) {
        navigationController?.pushViewController(ClassDetailViewController(classItem: classItem), animated: true)
    }
}
