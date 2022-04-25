//
//  Category.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/20.
//

import Foundation

enum Category {
    case korean
    case math
    case english
    case science
    case society
    case language
    case major
    case computer
    case hobby
    
    var text: String? {
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
}
