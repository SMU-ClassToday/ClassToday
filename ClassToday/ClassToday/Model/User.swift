//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct User: Codable, Equatable {
    let id: String
    let name: String
    let nickName: String
    let gender: String
    let location: Location?
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    let subjects: [Subject]?
    let chatItems: [String]?

    init(id: String = UUID().uuidString,
         name: String,
         nickName: String,
         gender: String,
         location: Location?,
         email: String,
         profileImage: String?,
         company: String?,
         description: String?,
         subjects: [Subject]?,
         chatItems: [String]?
    ) {
        self.id = id
        self.name = name
        self.nickName = nickName
        self.gender = gender
        self.location = location
        self.email = email
        self.profileImage = profileImage
        self.company = company
        self.description = description
        self.subjects = subjects
        self.chatItems = chatItems
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
