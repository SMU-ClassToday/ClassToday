//
//  ClassItem.swift
//  ClassToday
//
//  Created by yc on 2022/03/29.
//

import Foundation
import UIKit

struct ClassItem {
    let name: String
    let date: Set<Date>?
    let time: String?
    let place: String?
    let location: String?
    let price: String?
    let priceUnit: PriceUnit
    let description: String
    let images: [UIImage]?
    let subjects: Set<Subject>?
    let targets: Set<Target>?
    let itemType: ClassItemType
    let validity: Bool
    let writer: User
}

enum ClassItemType: String {
    case buy = "구매글"
    case sell = "판매글"
}
