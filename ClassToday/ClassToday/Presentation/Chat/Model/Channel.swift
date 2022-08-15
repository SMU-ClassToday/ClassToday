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
    var sellerID: String
    var buyerID: String
    let classItemID: String
    var match: Match?
    var validity: Bool
    
    init(sellerID: String, buyerID: String, classItem: ClassItem? = nil) {
        self.sellerID = sellerID
        self.buyerID = buyerID
        self.classItem = classItem
        self.classItemID = classItem?.id ?? ""
        self.validity = true
    }
}
