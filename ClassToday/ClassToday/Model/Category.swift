//
//  Category.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import Foundation

protocol CategoryItem {
    static var count: Int { get }
    var name: String { get }
}

enum CategoryType: CaseIterable {
    case subject
    case target
}

enum Subject: String, CategoryItem, CaseIterable {
    case korean = "국어"
    case english = "영어"
    case math = "수학"
    case science = "과학탐구"
    case society = "사회탐구"
    case computerScience = "컴퓨터공학"
    case coding = "코딩"
    case foreigneLanguage = "외국어"
    case hobby = "취미"

    static var count: Int {
        return Self.allCases.count
    }

    var name: String {
        return self.rawValue
    }
}

enum Target: String, CategoryItem, CaseIterable {
    case elementary = "초등학생"
    case university = "대학생"
    case junior = "중학생"
    case housewife = "주부"
    case senior = "고등학생"
    case all = "전연령"

    static var count: Int {
        return Self.allCases.count
    }

    var name: String {
        return self.rawValue
    }
}
