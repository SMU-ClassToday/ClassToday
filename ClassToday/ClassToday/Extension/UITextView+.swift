//
//  UITextView+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

extension UITextView {
    func numberOfLine() -> Int {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = sizeThatFits(size)

        return Int(estimatedSize.height / (self.font?.lineHeight ?? 0))
    }
}
