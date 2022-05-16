//
//  Review.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct ReviewItem: Codable {
    var id: String = UUID().uuidString
    let writerId: String
    let grade: Double
    let description: String
    let createdTime: Date
}
