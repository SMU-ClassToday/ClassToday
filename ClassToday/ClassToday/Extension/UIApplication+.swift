//
//  UIApplication+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/10.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
