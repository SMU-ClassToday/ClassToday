//
//  Match.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct Match: Codable {
    var id: String = UUID().uuidString
    var seller: String
    var buyer: String
    var dayWeek: [DayWeek]?
    var time: String?
    var place: Location?
    var location: Location
    var price: String?
    var priceUnit: PriceUnit
    var review: ReviewItem?
    
    init(seller: String, buyer: String, dayWeek: [DayWeek], time: String, place: Location, location: Location, price: String, priceUnit: PriceUnit) {
        self.seller = seller
        self.buyer = buyer
        self.dayWeek = dayWeek
        self.time = time
        self.place = place
        self.location = location
        self.price = price
        self.priceUnit = priceUnit
    }
}
