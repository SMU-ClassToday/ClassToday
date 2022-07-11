//
//  Channel.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import Foundation

// Channel.swift
struct Channel: Codable {
    var id: String = UUID().uuidString
    let classItem: ClassItem?
    let sellerID: String
    let buyerID: String
    
    init(sellerID: String, buyerID: String, classItem: ClassItem? = nil) {
        self.sellerID = sellerID
        self.buyerID = buyerID
        self.classItem = classItem
    }
}
