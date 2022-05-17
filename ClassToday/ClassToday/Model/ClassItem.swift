//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import UIKit
import CoreLocation

struct ClassItem: Codable {
    var id: String = UUID().uuidString
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
}
