//
//  Icon.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
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
    case xmark
    
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
            return UIImage(systemName: "list.bullet")
        case .star:
            return UIImage(systemName: "star")
        case .xmark:
            return UIImage(systemName: "xmark")
        }
    }
}
