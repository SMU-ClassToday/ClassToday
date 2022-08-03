//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct User: Codable, Equatable {
    var id: String = UUID().uuidString
    let name: String
    let nickName: String
    let gender: String
    let location: Location?
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    var stars: [String]?
    let subjects: [Subject]?
    let channels: [String]?
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = UserDefaultsManager.shared.isLogin() else { return }
        FirestoreManager.shared.readUser(uid: uid) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
