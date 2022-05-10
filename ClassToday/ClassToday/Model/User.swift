//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct User: Codable, Equatable {
    let name: String
    let email: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.name == rhs.name) && (lhs.email == rhs.email)
    }
}
