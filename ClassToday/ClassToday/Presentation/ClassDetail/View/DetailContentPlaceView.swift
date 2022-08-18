//
//  DetailContentPlaceView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/09.
//

import UIKit
import NMapsMap

class DetailContentPlaceView: UIView {

    // MARK: - Views

    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "수업장소"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .separator
        return sepertor
    }()

    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var mapView: NaverMapView = {
        let mapView = NaverMapView()
        return mapView
    }()

    private var location: Location? {
        willSet {
            guard let newValue = newValue else { return }
            mapView.configure(with: newValue)
        }
    }

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        [headLabel, seperator, placeLabel, mapView].forEach { addSubview($0) }

        headLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        seperator.snp.makeConstraints {
            $0.top.equalTo(headLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(seperator.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(16)
            $0.height.equalTo(self.snp.width)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureWith(place: String, location: Location) {
        placeLabel.text = place
        self.location = location
    }
}
