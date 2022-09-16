//
//  NaverUserInfo.swift
//  ClassToday
//
//  Created by yc on 2022/07/24.
//

import Foundation

struct NaverUserInfo: Decodable {
    let resultcode: String
    let message: String
    let response: NaverUserInfoResponse
    
    struct NaverUserInfoResponse: Decodable {
        let email: String
        let gender: String
        let id: String
        let name: String
    }
    
    func toUserForm() -> User {
        return User(
            id: self.response.id,
            name: self.response.name,
            nickName: self.response.name,
            gender: self.response.gender,
            location: nil,
            detailLocation: "",
            keywordLocation: "",
            email: self.response.email,
            profileImage: nil,
            company: nil,
            description: nil,
            stars: [],
            subjects: [],
            channels: []
        )
    }
}
