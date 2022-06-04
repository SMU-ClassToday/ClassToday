//
//  LocationManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/01.
//

import Foundation
import CoreLocation

enum LocationManagerError: Error {
    case invalidLocation
    case emptyPlacemark
    case emptyLocationValue
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
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
    
    // 위치권한정보 메서드
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func getCurrentLocation() -> Location? {
        guard let currentLocation = currentLocation else {
            return nil
        }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        return Location(lat: lat, lon: lon)
    }

    func getAddress(of location: Location?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let location = location else {
            return completion(.failure(LocationManagerError.emptyLocationValue))
        }
        let clLocation = CLLocation(latitude: location.lat, longitude: location.lon)
        getAddress(of: clLocation, completion: completion)
    }

    func getCurrentAddress(completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentLocation = currentLocation else {
            return
        }
        getAddress(of: currentLocation, completion: completion)
    }

    private func getAddress(of location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR")) { placemark, error in
            guard error == nil else {
                return completion(.failure(LocationManagerError.invalidLocation))
            }
            guard let placemark = placemark?.last else {
                return completion(.failure(LocationManagerError.emptyPlacemark))
            }
            guard let locality = placemark.locality else {
                return completion(.failure(LocationManagerError.emptyLocationValue))
            }
            var address = "\(locality)"
            if let subLocality = placemark.subLocality {
                address.append(contentsOf: " \(subLocality)")
            } else if let thoroughfare = placemark.thoroughfare {
                address.append(contentsOf: " \(thoroughfare)")
            }
            completion(.success(address))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
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
        delegate?.didUpdateLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
