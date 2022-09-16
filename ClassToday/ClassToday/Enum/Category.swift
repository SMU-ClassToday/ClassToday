//
//  Category.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import Foundation
import UIKit

enum CategoryType: CaseIterable {
    case subject
    case target
}

protocol CategoryItem: Codable {
    static var count: Int { get }
    var description: String { get }
}

enum Subject: String, CategoryItem, CaseIterable {
    case korean
    case math
    case english
    case science
    case society
    case language
    case major
    case computer
    case hobby

    static var count: Int {
        return Self.allCases.count
    }

    var description: String {
        switch self {
            case .korean:
                return "국어"
            case .math:
                return "수학"
            case .english:
                return "영어"
            case .science:
                return "과학"
            case .society:
                return "사회"
            case .language:
                return "외국어"
            case .major:
                return "전공"
            case .computer:
                return "컴퓨터"
            case .hobby:
                return "취미"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .korean:
            return "📖".image()
        case .math:
            return "📐".image()
        case .english:
            return "🔤".image()
        case .science:
            return "🔬".image()
        case .society:
            return "⚖️".image()
        case .language:
            return "🌐".image()
        case .major:
            return "🎓".image()
        case .computer:
            return "🖥".image()
        case .hobby:
            return "🛹".image()
        }
    }
}

enum Target: String, CategoryItem, CaseIterable {
    case elementary
    case university
    case junior
    case housewife
    case senior
    case all

    static var count: Int {
        return Self.allCases.count
    }

    var description: String {
        switch self {
        case .elementary:
            return "초등학생"
        case .university:
            return "대학생"
        case .junior:
            return "중학생"
        case .housewife:
            return "주부"
        case .senior:
            return "고등학생"
        case .all:
            return "전연령"
        }
    }
}

extension CategoryItem {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.description < rhs.description
    }
}
