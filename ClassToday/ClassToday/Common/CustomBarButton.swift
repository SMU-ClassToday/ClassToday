//
//  CustomBarButton.swift
//  ClassToday
//
//  Created by poohyhy on 2022/05/06.
//

import UIKit

extension UIBarButtonItem {
    //메뉴버튼 크기조정
    static func menuButton(_ target: Any?, action: Selector, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}
