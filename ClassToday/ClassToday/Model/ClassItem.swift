//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import UIKit
import CoreLocation

struct ClassItem: Codable, Equatable {
    var id: String = UUID().uuidString
    let name: String
    let date: Set<DayWeek>?
    let time: String?
    let place: String?
    let location: Location?
    let semiKeywordLocation: String?
    let keywordLocation: String?
    let price: String?
    let priceUnit: PriceUnit
    let description: String
    let images: [String]?
    let subjects: Set<Subject>?
    let targets: Set<Target>?
    let itemType: ClassItemType
    var validity: Bool
    var writer: String
    let createdTime: Date
    let modifiedTime: Date?

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
    
    /// 수업이 업로드 되고 경과된 시간을 계산하여, 문자열로 반환합니다.
    ///
    /// - form: " | @개월 전" [개월, 일, 시간, 분, 방금 전]
    func pastDateCalculate() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: self.createdTime, to: Date())
        var text = ""
        if let month = components.month, month != 0 {
            text = " | \(month)개월 전"
        } else if let day = components.day, day != 0 {
            text = " | \(day)일 전"
        } else if let hour = components.hour, hour != 0 {
            text = " | \(hour)시간 전"
        } else if let minute = components.minute, minute != 0 {
            text = " | \(minute)분 전"
        } else {
            text = " | 방금 전"
        }
        return text
    }
    
    static func > (lhd: Self, rhd: Self) -> Bool {
        return lhd.createdTime > rhd.createdTime
    }
}
