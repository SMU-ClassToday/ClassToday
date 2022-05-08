//
//  MockData.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import UIKit

struct MockData {
    static var classItem = ClassItem(name: "수학",
                                     date: [.mon,.wed,.fri],
                                     time: "2",
                                     place: nil,
                                     location: nil,
                                     price: "12000",
                                     priceUnit: .perClass,
                                     description: "수학모의고사 풀어드려요",
                                     images: [UIImage(named: "1.jpeg")!, UIImage(named: "2.jpeg")!],
                                     subjects: [.korean,.coding],
                                     targets: [.elementary,.senior],
                                     itemType: .sell,
                                     validity: true,
                                     writer: "me")
}
