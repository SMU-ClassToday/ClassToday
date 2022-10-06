//
//  Icon.swift
//  Practice
//
//  Created by yc on 2022/04/15.
//

import UIKit

/// 필요한 아이콘들을 enum으로 구현
enum Icon {
    case house
    case location
    case plus
    case chat
    case person
    case search
    case category
    case star
    case halfStar
    case fillStar
    case xmark
    case disclosureIndicator
    
    var image: UIImage? {
        switch self {
        case .house:
            return UIImage(systemName: "house")
        case .location:
            return UIImage(systemName: "mappin.and.ellipse")
        case .plus:
            return UIImage(systemName: "plus.circle")
        case .chat:
            return UIImage(systemName: "message")
        case .person:
            return UIImage(systemName: "person")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .category:
            return UIImage(systemName: "menucard")
        case .star:
            return UIImage(systemName: "star")
        case .halfStar:
            return UIImage(systemName: "star.leadinghalf.filled")
        case .fillStar:
            return UIImage(systemName: "star.fill")
        case .xmark:
            return UIImage(systemName: "xmark")
        case .disclosureIndicator:
            return UIImage(systemName: "chevron.right")
        }
    }
}
