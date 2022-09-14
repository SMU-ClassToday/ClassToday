//
//  UIToolBar+.swift
//  ClassToday
//
//  Created by Yescoach on 2022/08/16.
//

import UIKit

extension UIToolbar {
    /// 상단에 버튼이 포함된 키보드를 반환합니다.
    ///
    /// - title: 버튼의 텍스트
    /// - target: 버튼의 액션
    static func keyboardWithTopButton(title: String, target: Selector?) -> UIToolbar {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: title, style: .done, target: self, action: target!)
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.mainColor
        return toolBarKeyboard
    }
}
