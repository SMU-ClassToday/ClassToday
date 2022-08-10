//
//  MapSelectionViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/26.
//

import UIKit
import NMapsMap
import Moya

protocol MapSelectionViewControllerDelegate: AnyObject {
    func isLocationSelected(location: Location, place: String)
}

class MapSelectionViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수업 장소를 선택하세요"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var mapView: NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        let mapView = naverMapView.mapView
        mapView.mapType = NMFMapType.basic
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
        mapView.positionMode = NMFMyPositionMode.direction
        mapView.touchDelegate = self
        mapView.isTiltGestureEnabled = false
        mapView.isRotateGestureEnabled = false
        mapView.layer.cornerRadius = 16
        mapView.layer.masksToBounds = true
        return naverMapView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                    ⋇ 지도 영역을 탭하면, 해당 위치가 수업 장소로 등록됩니다.
                    """
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.text = "선택한 수업의 위치"
        label.isHidden = true
        return label
    }()
    
    private lazy var locationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("현재 위치로 설정하기", for: .normal)
        button.setTitleColor(UIColor.mainColor, for: .normal)
        button.addTarget(self, action: #selector(isResetButtonTouched(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("설정하기", for: .normal)
        button.setTitle("장소를 선택해주세요", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.setBackgroundColor(UIColor.mainColor, for: .normal)
        button.setBackgroundColor(UIColor.gray, for: .disabled)
        button.addTarget(self, action: #selector(isButtonTouched(_:)), for: .touchUpInside)
        return button
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
    
    weak var delegate: MapSelectionViewControllerDelegate?
    private let moyaProvider = NaverMapAPIProvider()
    private var placeName: String? {
        willSet {
            guard let newValue = newValue else {
                locationDescriptionLabel.text = "주소 정보 없음"
                return
            }
            locationDescriptionLabel.text = "\(newValue)"
        }
    }
    
    private var position: NMGLatLng? {
        willSet {
            guard let newValue = newValue else {
                marker.mapView = nil
                placeName = nil
                locationLabel.isHidden = true
                locationDescriptionLabel.isHidden = true
                resetButton.isHidden = true
                return
            }
            marker.position = newValue
            marker.mapView = mapView.mapView
            locationLabel.isHidden = false
            locationDescriptionLabel.isHidden = false
            resetButton.isHidden = false
            let location = Location(lat: newValue.lat, lon: newValue.lng)
            self.moyaProvider.locationToAddress(location: location) { address in
                self.placeName = address
                self.button.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        modalPresentationStyle = .pageSheet
    }
    
    func configure(location: Location? = nil) {
        guard let location = location else {
            guard let currentLocation = LocationManager.shared.getCurrentLocation() else { return }
            let position = NMGLatLng(lat: currentLocation.lat, lng: currentLocation.lon)
            mapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: position))
            return
        }
        position = NMGLatLng(lat: location.lat, lng: location.lon)
        resetButton.isHidden = false
    }
    
    private func setUpLayout() {
        view.backgroundColor = .white
        [
            titleLabel, mapView, descriptionLabel, locationLabel,
            resetButton ,locationDescriptionLabel, button
        ].forEach { view.addSubview($0)}
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        resetButton.snp.makeConstraints {
            $0.trailing.equalTo(mapView)
            $0.bottom.equalTo(mapView.snp.top)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(mapView)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(descriptionLabel)
            $0.trailing.equalTo(resetButton).offset(8)
        }
        locationDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(locationLabel)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(locationDescriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(mapView)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func isButtonTouched(_ sender: UIButton) {
        guard let position = position else {
            /// 선택된 좌표가 없는 경우
            /// 현재 위치와 주소명 리턴
            guard let location = LocationManager.shared.getCurrentLocation() else { return }
            moyaProvider.locationToAddress(location: location) { [weak self] address in
                guard let self = self else { return }
                self.delegate?.isLocationSelected(location: location, place: address)
            }
            dismiss(animated: true)
            return
        }
        let location = Location(lat: position.lat, lon: position.lng)
        delegate?.isLocationSelected(location: location, place: placeName ?? "주소 정보 없음")
        dismiss(animated: true)
    }

    @objc func isResetButtonTouched(_ sender: UIButton) {
        guard let location = LocationManager.shared.getCurrentLocation() else { return }
        position = NMGLatLng(lat: location.lat, lng: location.lon)
    }
}

extension MapSelectionViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        position = latlng
    }
}
