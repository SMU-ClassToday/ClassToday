//
//  UIImageView+.swift
//  ClassToday
//
//  Created by yc on 2022/06/01.
//

import UIKit

extension UIImageView {
    var starImageView: UIImageView {
        self.image = Icon.star.image
        self.contentMode = .scaleAspectFit
        self.tintColor = .systemYellow
        return self
    }
}
