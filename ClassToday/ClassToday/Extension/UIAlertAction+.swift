//
//  UIAlertAction+.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/04.
//

import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
