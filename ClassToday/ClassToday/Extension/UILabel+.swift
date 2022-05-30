//
//  UILabel+.swift
//  ClassToday
//
//  Created by yc on 2022/05/03.
//

import UIKit

extension UILabel {
    /// 라벨의 텍스트 중간에 사이즈를 다르게 적용하는 메서드
    ///
    /// - text: 라벨의 전체 텍스트
    /// - bigText: 큰 사이즈를 적용할 텍스트
    /// - fontSize: 전체 폰트 사이즈
    /// - bigFontSize: 큰 사이즈의 폰트 크기
    /// - weight: 전체 폰트의 weight
    /// - bigWeight: 큰 사이즈의 weight
    func bigFontSize(text: String, bigText: String, fontSize: CGFloat, bigFontSize: CGFloat, weight: UIFont.Weight, bigWeight: UIFont.Weight) {
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: bigFontSize, weight: bigWeight)],
            range: NSString(string: text).range(of: bigText))
        self.attributedText = attributedString
    }
}
