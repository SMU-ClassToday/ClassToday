//
//  UIButton+.swift
//  ClassToday
//
//  Created by yc on 2022/06/01.
//

import UIKit

extension UIButton {
    func makeSNSStyleButton(
        title: String,
        image: UIImage?,
        titleColor: UIColor,
        tintColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        self.setImage(image, for: .normal)
        self.tintColor = tintColor
        self.layer.cornerRadius = 4.0
        self.backgroundColor = backgroundColor
        self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -5.0)
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
