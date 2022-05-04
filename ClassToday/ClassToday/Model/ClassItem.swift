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
    let date: String?
    let time: String?
    let place: String?
    let location: String?
    let price: String?
    let priceUnit: String
    let description: String
    let images: [UIImage]?
    let subjects: [Subject]?
    let targets: [Target]?
    let itemType: String
    let validity: Bool
    let writer: String
}
