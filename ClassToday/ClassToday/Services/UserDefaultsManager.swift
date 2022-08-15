//
//  UserDefaultsManager.swift
//  ClassToday
//
//  Created by yc on 2022/07/27.
//

import Foundation

enum LoginType: String {
    case naver
    case email
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let statusKey = "LoginStatus"
    private let typeKey = "LoginType"
    private let standard = UserDefaults.standard
    
    func isLogin() -> String? {
        return standard.string(forKey: statusKey)
    }
    func getLoginType() -> LoginType? {
        guard let str = standard.string(forKey: typeKey) else { return nil }
        return LoginType(rawValue: str)
    }
    
    
    func saveLoginStatus(uid: String, type: LoginType) {
        standard.set(uid, forKey: statusKey)
        standard.set(type.rawValue, forKey: typeKey)
    }
    
    func removeLoginStatus() {
        standard.removeObject(forKey: statusKey)
        standard.removeObject(forKey: typeKey)
    }
}
