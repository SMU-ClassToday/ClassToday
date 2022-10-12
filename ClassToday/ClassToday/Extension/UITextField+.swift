//
//  UITextField+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/22.
//

import UIKit

// MARK: UITextField UI 작업

extension UITextField {
    func configureWith(placeholder: String) {
        self.placeholder = placeholder
        setPlaceholderColor(.systemGray4)
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
    }

    private func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [.foregroundColor: placeholderColor, .font: font].compactMapValues { $0 })
    }

    func setUnderLine() {
        let border = CALayer()
        guard let window = window else { return }
        border.frame = CGRect(x: 0, y: 60, width: window.frame.width - 32, height: 1.5)
        border.borderWidth = 1.0
        border.backgroundColor = UIColor.systemGray5.cgColor
        border.borderColor = UIColor.systemGray5.cgColor
        borderStyle = .none
        layer.masksToBounds = false
        self.layer.addSublayer(border)
    }
}
