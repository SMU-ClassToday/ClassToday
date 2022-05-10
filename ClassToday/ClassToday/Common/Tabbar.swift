//
//  TabbarData.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit

enum Tabbar: CaseIterable {
    case main
    case map
    case upload
    case chat
    case profile
    
    var viewController: UIViewController {
        switch self {
        case .main:
            return UINavigationController(rootViewController: MainViewController())
        case .map:
            return MapViewController()
        case .upload:
            return UIViewController()
        case .chat:
            return ChatViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: nil,
                image: Icon.house.image,
                selectedImage: nil
            )
        case .map:
            return UITabBarItem(
                title: nil,
                image: Icon.location.image,
                selectedImage: nil
            )
        case .upload:
            return UITabBarItem(
                title: nil,
                image: Icon.plus.image,
                selectedImage: nil
            )
        case .chat:
            return UITabBarItem(
                title: nil,
                image: Icon.chat.image,
                selectedImage: nil
            )
        case .profile:
            return UITabBarItem(
                title: nil,
                image: Icon.person.image,
                selectedImage: nil
            )
        }
    }
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
