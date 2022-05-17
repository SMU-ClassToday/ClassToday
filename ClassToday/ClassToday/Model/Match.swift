//
//  Match.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct Match: Codable {
    var id: String = UUID().uuidString
    let seller: String
    let buyer: String
    let dayWeek: [DayWeek]?
    let time: String?
    let place: Location?
    let location: Location?
    let price: String?
    let priceUnit: PriceUnit
    let review: ReviewItem?
}
