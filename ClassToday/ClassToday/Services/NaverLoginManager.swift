//
//  NaverLoginManager.swift
//  ClassToday
//
//  Created by yc on 2022/07/24.
//

import Foundation
import Alamofire
import NaverThirdPartyLogin

class NaverLoginManager {
    static let shared = NaverLoginManager()
    
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func getInfo(completion: @escaping (Result<NaverUserInfo, AFError>) -> Void) {
        let isValidAccessToken = instance?.isValidAccessTokenExpireTimeNow()
        
        if !(isValidAccessToken ?? false) { return }
        
        guard let tokenType = instance?.tokenType,
              let accessToken = instance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        guard let url = URL(string: urlStr) else { return }
        
        let headers: HTTPHeaders = ["Authorization": "\(tokenType) \(accessToken)"]
        
        AF
            .request(url, method: .get, headers: headers)
            .responseDecodable(of: NaverUserInfo.self) { response in
                switch response.result {
                case .success(let userInfo):
                    completion(.success(userInfo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func signOut() {
        instance?.resetToken()
    }
}
