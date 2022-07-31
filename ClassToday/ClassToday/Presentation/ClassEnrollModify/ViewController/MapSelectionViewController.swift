//
//  MapSelectionViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/26.
//

import UIKit
import NMapsMap

class MapSelectionViewController: UIViewController {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "수업 장소를 선택하세요"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        label.isHidden = true
        return label
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

    var completion: ((NMGLatLng) -> Void)?

    private var position: NMGLatLng? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            marker.position = newValue
            marker.mapView = mapView.mapView
            locationLabel.isHidden = false
            locationLabel.text = "선택한 수업의 위치: \(newValue.lat.rounded()), \(newValue.lng.rounded())"
            button.isEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        modalPresentationStyle = .pageSheet
    }

    func configure(completion: @escaping ((NMGLatLng) -> Void)) {
        self.completion = completion
    }

    private func setUpLayout() {
        view.backgroundColor = .white
        [label, mapView, descriptionLabel, locationLabel, button].forEach { view.addSubview($0)}
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(mapView)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(descriptionLabel)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(mapView)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func isButtonTouched(_ sender: UIButton) {
        guard let position = position else {
            return
        }
        completion?(position)
        dismiss(animated: true)
    }
}

extension MapSelectionViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        position = latlng
    }
}
