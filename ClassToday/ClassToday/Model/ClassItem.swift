//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import UIKit
import CoreLocation

struct ClassItem: Codable {
    var id: String = UUID().uuidString
    let name: String
    let date: Set<DayWeek>?
    let time: String?
    let place: String?
    let location: Location?
    let price: String?
    let priceUnit: PriceUnit
    let description: String
    let images: [String]?
    let subjects: Set<Subject>?
    let targets: Set<Target>?
    let itemType: ClassItemType
    let validity: Bool
    let writer: User
    let createdTime: Date
    let modifiedTime: Date?
    let match: [Match]?

    func thumbnailImage(completion: @escaping (UIImage?) -> Void) {
        guard let imagesURL = images, let url = imagesURL.first  else {
            completion(nil)
            return
        }
        if let cachedImage = ImageCacheManager.shared.object(forKey: url as NSString) {
            completion(cachedImage)
        }
        StorageManager.shared.downloadImage(urlString: url) { result in
            switch result {
            case .success(let image):
                ImageCacheManager.shared.setObject(image, forKey: url as NSString)
                completion(image)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    func fetchedImages(completion: @escaping ([UIImage]?) -> Void) {
        var fetchedImages: [UIImage] = []
        let group = DispatchGroup()
        if let imagesURL = images {
            for url in imagesURL {
                if let cachedImage = ImageCacheManager.shared.object(forKey: url as NSString) {
                    fetchedImages.append(cachedImage)
                } else {
                    group.enter()
                    StorageManager.shared.downloadImage(urlString: url) { result in
                        switch result {
                        case .success(let image):
                            ImageCacheManager.shared.setObject(image, forKey: url as NSString)
                            fetchedImages.append(image)
                        case .failure(let error):
                            debugPrint(error)
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: DispatchQueue.main) {
                completion(fetchedImages)
            }
        } else {
            completion(nil)
        }
    }
}
