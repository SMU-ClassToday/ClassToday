//
//  Extension + String.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import Foundation

extension String {
    func formmatedWithCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        let result = formatter.string(from: (Int(self) ?? 0) as NSNumber)
        return result ?? ""
    }
}
