//
//  NetworkManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/31.
//

import Foundation
import Moya

class NaverMapAPIProvider {
    let provider: MoyaProvider<NaverMapAPI>
    
    init(provider: MoyaProvider<NaverMapAPI> = .init()) {
        self.provider = provider
    }
    
    /// 도로명주소를 반환합니다.
    func locationToDetailAddress(location: Location, completion: @escaping (String) -> Void ) {
        provider.request(.reverseGeocoding(location.lat, location.lon)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(NaverMapAddress.self) else { return }
                guard let results = data.results.first else { return }
                /// roadAddr
                let address: [String] = [
                    results.region.area1.name, results.region.area2.name,
                    results.region.area3.name, results.region.area4.name,
                    results.land.name, results.land.number1, results.land.addition0.value
                ].compactMap {$0}
                let addrString = (address as AnyObject).componentsJoined(by: " ")
                completion(addrString)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    /// 주소를  받아옵니다
    /// - @@시 ##구
    func locationToKeywordAddress(location: Location, completion: @escaping (String) -> Void) {
        provider.request(.reverseGeocoding(location.lat, location.lon)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(NaverMapAddress.self) else { return }
                guard let results = data.results.first else { return }
                /// roadAddr
                let address: [String] = [
                    results.region.area1.name, results.region.area2.name
                ].compactMap {$0}
                let addrString = (address as AnyObject).componentsJoined(by: " ")
                completion(addrString)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    /// 키워드 주소를 받아옵니다
    /// - ##구
    func locationToKeyword(location: Location?, completion: @escaping (String) -> Void) {
        guard let location = location else { return }
        provider.request(.reverseGeocoding(location.lat, location.lon)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(NaverMapAddress.self) else { return }
                guard let results = data.results.first,
                      let keyword = results.region.area2.name else { return }
                completion(keyword)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func locationToSemiKeyword(location: Location?, completion: @escaping (String) -> Void) {
        guard let location = location else { return }
        provider.request(.reverseGeocoding(location.lat, location.lon)) { result in
            switch result {
            case .success(let response):
                guard let data = try? response.map(NaverMapAddress.self) else { return }
                guard let results = data.results.first,
                      let keyword = results.region.area3.name else { return }
                completion(keyword)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

extension String {
    func append(contentsOf newElement: String?) {
        guard let string = newElement else {
            return
        }
        self.append(contentsOf: string)
    }
}
