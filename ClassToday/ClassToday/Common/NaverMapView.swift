//
//  MapView.swift
//  ClassToday
//
//  Created by Yescoach on 2022/08/17.
//

import UIKit
import NMapsMap

class NaverMapView: UIView {
    private lazy var mapView: NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        let mapView = naverMapView.mapView
        mapView.mapType = NMFMapType.basic
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        mapView.isTiltGestureEnabled = false
        mapView.isRotateGestureEnabled = false
        mapView.isScrollGestureEnabled = false
        return naverMapView
    }()

    private lazy var marker: NMFMarker = {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.mainColor
        marker.iconPerspectiveEnabled = true
        marker.width = 30
        marker.height = 40
        return marker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with location: Location) {
        let position = NMGLatLng(lat: location.lat, lng: location.lon)
        mapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: position))
        marker.position = position
        marker.mapView = mapView.mapView
    }
}
