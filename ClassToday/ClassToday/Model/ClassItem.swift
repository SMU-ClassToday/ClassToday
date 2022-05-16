//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation
import UIKit
import CoreLocation

struct ClassItem: Codable {
    let id: String
    let name: String
    let date: Set<DayWeek>?
    let time: String?
    let place: String?
    let location: Location?
    let price: String?
    let priceUnit: PriceUnit
    let description: String
    let images: [String]?
    let subjects: Set<Subject>?
    let targets: Set<Target>?
    let itemType: ClassItemType
    let validity: Bool
    let writer: User
    let createdTime: Date
    let modifiedTime: Date?
    let match: [Match]?

    init(id: String = UUID().uuidString,
         name: String,
         date: Set<DayWeek>?,
         time: String?,
         place: String?,
         location: Location?,
         price: String?,
         priceUnit: PriceUnit,
         description: String,
         images: [String]?,
         subjects: Set<Subject>?,
         targets: Set<Target>?,
         itemType: ClassItemType,
         validity: Bool,
         writer: User,
         createdTime: Date,
         modifiedTime: Date?,
         match: [Match]?
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.time = time
        self.place = place
        self.location = location
        self.price = price
        self.priceUnit = priceUnit
        self.description = description
        self.images = images
        self.subjects = subjects
        self.targets = targets
        self.itemType = itemType
        self.validity = validity
        self.writer = writer
        self.createdTime = createdTime
        self.modifiedTime = modifiedTime
        self.match = match
    }
}
