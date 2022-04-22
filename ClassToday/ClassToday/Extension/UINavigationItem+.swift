//
//  UINavigationItem+.swift
//  Practice
//
//  Created by yc on 2022/04/15.
//

import UIKit

extension UINavigationItem {
    /// 네비게이션 바의 왼쪽 타이틀을 설정하는 메서드
    func setLeftTitle(text: String) {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        self.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
}
