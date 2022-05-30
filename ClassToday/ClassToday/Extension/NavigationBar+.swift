//
//  NavigationBar+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/09.
//

import UIKit

extension UINavigationBar {
    static var statusBarSize: CGSize {
        var size: CGSize = CGSize()
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            size = window.windowScene?.statusBarManager?.statusBarFrame.size ?? CGSize()
        }
        return size
    }
    static var navigationBarSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }

    static var navigationItemSize: CGSize {
        return CGSize(width: 24, height: 24)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let height = UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale
        return height == 812 || height == 896
    }
}
