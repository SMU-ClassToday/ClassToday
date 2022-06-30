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
    private lazy var categoryCollectionView: DetailContentCategoryView = {
        let collectionView = DetailContentCategoryView()
        return collectionView
    }()
    
    private lazy var mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        mapView.mapView.mapType = NMFMapType.basic
        mapView.mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        return mapView
    }()

    private var curLocation: Location? {
        return LocationManager.shared.getCurrentLocation()
    }

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
        print(#function)
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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

//extension MapViewController: NMFMapViewOptionDelegate {
//    func mapViewOptionChanged(_ mapView: NMFMapView) {
//        mapView.latitude = curLocation?.lat ?? 0
//        mapView.longitude = curLocation?.lon ?? 0
//    }
//}
