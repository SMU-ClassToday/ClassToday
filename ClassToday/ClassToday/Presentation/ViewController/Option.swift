//
//  Option.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit

enum Option: String, CaseIterable {
    case location = "내 위치 설정"
    case category = "관심 카테고리 설정"
    case notice = "공지사항"
    case QnA = "QnA"
    case question = "문의"
    case setting = "설정"
    
    var viewController: UIViewController {
        switch self {
        case .location:
            return UIViewController()
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
