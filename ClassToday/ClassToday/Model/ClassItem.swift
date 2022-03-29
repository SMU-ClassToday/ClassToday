//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation

struct ClassItem: Codable {
    let name: String
    let isPurchase: Bool
    let images: [String]?
    let place: String?
    let location: String
    let price: String?
    let date: String?
    let description: String
}
