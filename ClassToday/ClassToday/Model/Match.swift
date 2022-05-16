//
//  Match.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct Match: Codable {
    let id: String
    let seller: String
    let buyer: String
    let dayWeek: [DayWeek]?
    let time: String?
    let place: Location?
    let location: Location?
    let price: String?
    let priceUnit: PriceUnit
    let review: ReviewItem?

    init(id: String = UUID().uuidString,
         seller: String,
         buyer: String,
         dayWeek: [DayWeek]?,
         time: String?,
         place: Location?,
         location: Location?,
         price: String?,
         priceUnit: PriceUnit,
         review: ReviewItem?
    ) {
        self.id = id
        self.seller = seller
        self.buyer = buyer
        self.dayWeek = dayWeek
        self.time = time
        self.place = place
        self.location = location
        self.price = price
        self.priceUnit = priceUnit
        self.review = review
    }
}
