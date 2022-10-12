//
//  Option.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit

protocol MenuListable {
    var text: String { get }
}

enum Option: String, CaseIterable, MenuListable {
    case location = "내 위치 설정"
    case category = "관심 카테고리 설정"
    case notice = "공지사항"
    case QnA = "QnA"
    case question = "문의"
    case setting = "설정"
    
    var viewController: UIViewController {
        switch self {
        case .location:
            return LocationSettingViewController()
        case .category:
            return UIViewController()
        case .notice:
            return UIViewController()
        case .QnA:
            return UIViewController()
        case .question:
            return UIViewController()
        case .setting:
            return SettingViewController()
        }
    }
    
    var text: String { self.rawValue }
}
