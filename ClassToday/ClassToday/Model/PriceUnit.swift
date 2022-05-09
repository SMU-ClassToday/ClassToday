//
//  PriceUnit.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/07.
//

import Foundation

enum PriceUnit: CaseIterable {
    case perHour
    case perProblem
    case perClass

    var description: String {
        switch self {
        case .perHour:
            return "시간당"
        case .perProblem:
            return "문제당"
        case .perClass:
            return "수업당"
        }
    }
}
