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
    let location: Location?
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    var stars: [String]?
    let subjects: [Subject]?
    let chatItems: [String]?
    
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
}
