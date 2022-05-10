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
                                     images: [UIImage(named: "1.jpeg")!, UIImage(named: "2.jpeg")!],
                                     subjects: [.korean,.coding, .computerScience, .foreigneLanguage],
                                     targets: [.elementary,.senior],
                                     itemType: .sell,
                                     validity: true,
                                     writer: userInfo)
    static let userInfo = User(name: "yescoach", email: "sbsii1020@gmail.com")
}
