//
//  MapView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/17.
//

import UIKit
import NMapsMap

class MapView: UIView {
    private lazy var mapView: NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        let mapView = naverMapView.mapView
        mapView.mapType = NMFMapType.basic
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        mapView.positionMode = NMFMyPositionMode.direction
        return naverMapView
    }()
    
    private var markers: [NMFMarker] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        self.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setUpLocation(location: Location) {
        let coord = NMGLatLng(lat: location.lat, lng: location.lon)
        mapView.mapView.latitude = coord.lat
        mapView.mapView.longitude = coord.lng
    }
    
    func configureClassItemMarker(classItem: ClassItem, completion: @escaping (ClassItem) -> ()) {
        guard let location = classItem.location else { return }
        let marker = NMFMarker()
        let coord = NMGLatLng(lat: location.lat, lng: location.lon)
        marker.position = NMGLatLng(lat: coord.lat, lng: coord.lng)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.mainColor
        marker.iconPerspectiveEnabled = true
        marker.captionText = classItem.name
        marker.captionColor = UIColor.mainColor
        marker.captionHaloColor = UIColor.white
        marker.isHideCollidedCaptions = true
        marker.isHideCollidedSymbols = true
        marker.width = 30
        marker.height = 40
        marker.mapView = mapView.mapView
        marker.touchHandler = { _ -> Bool in
            completion(classItem)
            return false
        }
        markers.append(marker)
        marker.infoWindow?.open(with: marker)
    }
    
    func removeMarkers() {
        markers.forEach { $0.mapView = nil }
        markers = []
    }
}
