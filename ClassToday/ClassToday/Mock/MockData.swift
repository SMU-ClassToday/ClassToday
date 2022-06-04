//
//  MockData.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import UIKit

struct MockData {
    static let classItem = ClassItem(name: "수학",
                                     date: [.mon,.wed,.fri],
                                     time: "2",
                                     place: nil,
                                     location: nil,
                                     price: "12000",
                                     priceUnit: .perClass,
                                     description:
                                     """
                                     금년도 6월 수학 가형 모의고사 문제들을 토대로 수학 질문 및
                                     모의고사 풀이 전략등을 주제로 간단한 수업 진행하려고 합니다!
                                     수능 현역 및 재수생분들 편하게 연락주세요.

                                     21학년도 수능 수학영역 1등급
                                     *** 수학학원 고등부 문제풀이 조교 경험 多
                                     평가원 모의고사 수학영역 질문 클래스 진행경험 多
                                     """,
                                     images: ["1.jpeg", "2.jpeg"],
                                     subjects: [.korean, .computer, .english, .major],
                                     targets: [.elementary,.senior],
                                     itemType: .sell,
                                     validity: true,
                                     writer: mockUser,
                                     createdTime: Date(),
                                     modifiedTime: nil,
                                     match: nil
    )
    
    static let mockLocation = Location(lat: 11.1111, lon: 11.1111)

    static var mockUser = User(
        name: "이영찬",
        nickName: "Cobugi",
        gender: "남",
        location: mockLocation,
        email: "yc13033@gmail.com",
        profileImage: nil,
        company: "상명대학교 수학교육과",
        description: "수학에 관심이 많은, 개발자를 지망하는 수학교육 전공자입니다. 궁금하신 점은 메세지 문의 언제든지 주세요!",
        stars: ["ABB60E50-C5DA-4049-A0AC-FB078912F913", "57E3D0E7-70E7-41D4-A84F-1D26DF3AEC57"],
        subjects: [.korean, .math, .english, .science, .hobby],
        chatItems: nil
    )

    static let mockUser2 = User(
        name: "박태현",
        nickName: "YesCoach",
        gender: "남",
        location: mockLocation,
        email: "test123@gmail.com",
        profileImage: nil,
        company: "상명대학교 한일문화콘텐츠전공",
        description: "수학에 관심이 많은, 개발자를 지망하는 일본어 전공자입니다. 궁금하신 점은 메세지 문의 언제든지 주세요!",
        stars: nil,
        subjects: [.korean, .math, .english, .science, .hobby],
        chatItems: nil
    )

}
