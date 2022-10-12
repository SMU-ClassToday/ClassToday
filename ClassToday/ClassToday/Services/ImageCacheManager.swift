//
//  ImageCacheManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/22.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
