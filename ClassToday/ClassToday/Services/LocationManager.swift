//
//  LocationManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/01.
//

import UIKit
import CoreLocation

enum LocationManagerError: Error {
    case invalidLocation
    case emptyPlacemark
    case emptyPlacemarkLocality
    case emptyPlacemarkSubLocality
    case emptyLocationValue
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
    func didUpdateAuthorization()
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    weak var delegate: LocationManagerDelegate?

    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    /// 위치권한정보 메서드
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    /// 현재 기기의 위치를 반환합니다.
    func getCurrentLocation() -> Location? {
        guard let currentLocation = currentLocation else {
            return nil
        }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        return Location(lat: lat, lon: lon)
    }

    /// 위치에 해당하는 주소를 반환합니다.
//    func getAddress(of location: Location?, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let location = location else {
//            return completion(.failure(LocationManagerError.emptyLocationValue))
//        }
//        let clLocation = CLLocation(latitude: location.lat, longitude: location.lon)
//        getAddress(of: clLocation, completion: completion)
//    }

//    /// 현재 기기의 주소를 반환합니다.
//    func getCurrentAddress(completion: @escaping (Result<String, Error>) -> Void) {
//        guard let currentLocation = currentLocation else {
//            return
//        }
//        getAddress(of: currentLocation, completion: completion)
//    }

    /// 수업 아이템의 기준이 되는 위치정보를 반환합니다
    ///
    /// - 기준이 되는 위치정보: subLocality(1순위, @@동), thoroughfare(2순위, @@동)
    func getKeywordOfLocation(of location: Location?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let location = location else {
            return completion(.failure(LocationManagerError.emptyLocationValue))
        }
        let clLocation = CLLocation(latitude: location.lat, longitude: location.lon)
        CLGeocoder().reverseGeocodeLocation(clLocation, preferredLocale: Locale(identifier: "ko_KR")) { placemark, error in
            guard error == nil else {
                return completion(.failure(LocationManagerError.invalidLocation))
            }
            guard let placemark = placemark?.last else {
                return completion(.failure(LocationManagerError.emptyPlacemark))
            }
            guard let subLocality = placemark.subLocality else {
                guard let thoroughfare = placemark.thoroughfare else {
                    return completion(.failure(LocationManagerError.emptyPlacemarkSubLocality))
                }
                return completion(.success(thoroughfare))
            }
            return completion(.success(subLocality))
        }
    }
    
    /// locality 받는 메소드
    ///
    /// - locality: @@시
    func getLocality(of location: Location?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let location = location else {
            return completion(.failure(LocationManagerError.emptyLocationValue))
        }
        let clLocation = CLLocation(latitude: location.lat, longitude: location.lon)
        CLGeocoder().reverseGeocodeLocation(clLocation, preferredLocale: Locale(identifier: "ko_KR")) { placemark, error in
            guard error == nil else {
                return completion(.failure(LocationManagerError.invalidLocation))
            }
            guard let placemark = placemark?.last else {
                return completion(.failure(LocationManagerError.emptyPlacemark))
            }
            guard let locality = placemark.administrativeArea else {
                return completion(.failure(LocationManagerError.emptyPlacemarkLocality))
            }
            completion(.success(locality))
        }
    }
    
    /// 위치정보권한이 활성화 되었는지 판단하는 메서드
    func isLocationAuthorizationAllowed() -> Bool {
        return [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse, .notDetermined].contains(locationManager.authorizationStatus)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // TODO: 권한이 없는 경우 권한을 받도록 대응해야함
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didUpdateAuthorization()
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("권한없음")
        default:
            print("알수없음")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location
        manager.stopUpdatingLocation()
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager {
    /// Location을 CLLocation 타입으로 변경 후 호출해서 사용합니다.
    /// Address가 필요한 경우 **getAddress(of location: Location, completion: ...)** 메서드를 사용하세요.
//    private func getAddress(of location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
//        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR")) { placemark, error in
//            guard error == nil else {
//                return completion(.failure(LocationManagerError.invalidLocation))
//            }
//
//            guard let placemark = placemark?.first else {
//                return completion(.failure(LocationManagerError.emptyPlacemark))
//            }
//
//            guard let locality = placemark.administrativeArea else {
//                return completion(.failure(LocationManagerError.emptyPlacemarkLocality))
//            }
//            var address = "\(locality)"
//            if let thoroughfare = placemark.subAdministrativeArea {
//                address.append(contentsOf: " \(thoroughfare)")
//            }
//
//            print(placemark.subLocality)
//            completion(.success(address))
//        }
//    }
}
