//
//  String+.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import UIKit

extension String {
    func formattedWithWon() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: (Int(self) ?? 0) as NSNumber) else {
            return ""
        }
        return result + "원"
    }
    /// 이모지를 이미지로 변환합니다.
    func image() -> UIImage? {
        let size = CGSize(width: 46, height: 46)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
