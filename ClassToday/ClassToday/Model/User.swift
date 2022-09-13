//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import UIKit

struct User: Codable, Equatable {
    var id: String = UUID().uuidString
    let name: String
    let nickName: String
    let gender: String
    var location: String?
    /// 주소 문자열(@@시 ##구)
    var detailLocation: String?
    /// 키워드 주소 문자열(##구)
    var keywordLocation: String?
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    var stars: [String]?
    let subjects: [Subject]?
    var channels: [String]?
    var purchasedClassItems: [String]?
    var soldClassItemss: [String]?
    
    func thumbnailImage(completion: @escaping (UIImage?) -> Void) {
        guard let profileImageURL = profileImage else {
            return completion(nil)
        }
        if let cachedImage = ImageCacheManager.shared.object(forKey: profileImageURL as NSString) {
            completion(cachedImage)
        }
        StorageManager.shared.downloadImage(urlString: profileImageURL) { result in
            switch result {
            case .success(let image):
                ImageCacheManager.shared.setObject(image, forKey: profileImageURL as NSString)
                completion(image)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
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
