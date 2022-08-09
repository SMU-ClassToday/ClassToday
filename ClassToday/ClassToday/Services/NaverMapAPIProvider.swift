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
    
    func locationToAddress(location: Location, completion: @escaping (String) -> Void ) {
        provider.request(.reverseGeocoding(location.lat, location.lon)) { result in
            switch result {
            case .success(let response):
                print(response)
                print(result)
                let result = try? response.map(NaverMapAddress.self)
                let address: String = ""
                address.append(contentsOf: result?.region.area1?.name ?? "")
                address.append(contentsOf: result?.region.area2?.name ?? "")
                address.append(contentsOf: result?.region.area3?.name ?? "")
                address.append(contentsOf: result?.region.area4?.name ?? "")
                address.append(contentsOf: result?.land.name ?? "")
                address.append(contentsOf: result?.addition0?.value ?? "")
                completion(address)
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
