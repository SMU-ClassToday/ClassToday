//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct User: Codable, Equatable {
    var id: String = UUID().uuidString
    let name: String
    let nickName: String
    let gender: String
    let location: Location?
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    let stars: [String]?
    let subjects: [Subject]?
    let chatItems: [String]?

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
