//
//  ChatItem.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct ChatItem: Codable {
    var id: String = UUID().uuidString
    let classItemID: String
    let sellerID: String
    let buyerID: String
    let messages: [Message]?
}

struct Message: Codable {
    let senderID: String
    let body: String
    let date: Date
}
