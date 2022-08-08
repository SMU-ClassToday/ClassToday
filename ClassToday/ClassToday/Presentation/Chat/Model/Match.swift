//
//  Match.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct Match: Codable {
    var id: String = UUID().uuidString
    var seller: User
    var buyer: User
    var date: Set<DayWeek>?
    var time: String?
    var place: String?
    var location: Location?
    var price: String?
    var priceUnit: PriceUnit?
    var review: ReviewItem?
    
    init(seller: User,
         buyer: User,
         date: Set<DayWeek>?,
         time: String?,
         place: String?,
         location: Location?,
         price: String?,
         priceUnit: PriceUnit?) {
        self.seller = seller
        self.buyer = buyer
        self.date = date
        self.time = time
        self.place = place
        self.location = location
        self.price = price
        self.priceUnit = priceUnit
    }
}
