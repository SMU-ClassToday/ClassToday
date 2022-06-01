//
//  String+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import Foundation

extension String {
    func formattedWithWon() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: (Int(self) ?? 0) as NSNumber) else {
            return ""
        }
        return result + "원"
    }
}
