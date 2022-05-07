//
//  User.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct User: Equatable {
    private var id = UUID().uuidString
    let name: String
    let nickName: String
    let gender: String
    let location: String
    let email: String
    let profileImage: String?
    let company: String?
    let description: String?
    let subjects: [Subject?]
    let chatItems: String?
    
    static let mockUser = User(
        name: "이영찬",
        nickName: "Cobugi",
        gender: "남",
        location: "인천 미추홀구 용현 5동",
        email: "yc13033@gmail.com",
        profileImage: nil,
        company: "상명대학교 수학교육과",
        description: "수학에 관심이 많은, 개발자를 지망하는 수학교육 전공자입니다. 궁금하신 점은 메세지 문의 언제든지 주세요!",
        subjects: [.korean, .math, .english, .science, .hobby],
        chatItems: nil
    )
    static let mockUser2 = User(
        name: "박태현",
        nickName: "YesCoach",
        gender: "남",
        location: "서울시 노원구 상계1동",
        email: "test123@gmail.com",
        profileImage: nil,
        company: "상명대학교 한일문화콘텐츠전공",
        description: "수학에 관심이 많은, 개발자를 지망하는 일본어 전공자입니다. 궁금하신 점은 메세지 문의 언제든지 주세요!",
        subjects: [.korean, .math, .english, .science, .hobby],
        chatItems: nil
    )
}
