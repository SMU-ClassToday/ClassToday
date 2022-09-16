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
    
    /*function will return reference to tabbarcontroller */
    func tabbarController() -> UIViewController? {
        guard let vcs = self.keyWindow?.rootViewController?.children else { return nil }
        if let vc = self.keyWindow?.rootViewController as? TabbarController {
            return vc
        }
        for vc in vcs {
            if  let _ = vc as? TabbarController {
                return vc
            }
        }
        return nil
    }
}
