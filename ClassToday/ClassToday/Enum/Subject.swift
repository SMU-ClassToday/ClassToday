//
//  Subject.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import Foundation

enum Subject: String, CaseIterable {
    case korean = "국어"
    case math = "수학"
    case english = "영어"
    case social = "사회"
    case science = "과학"
    case computerScience = "컴퓨터공학"
    case coding = "코딩"
    case language = "외국어"
    case hobby = "취미"
    
    var text: String { self.rawValue }
}
