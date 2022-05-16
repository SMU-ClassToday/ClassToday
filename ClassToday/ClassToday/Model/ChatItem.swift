//
//  ChatItem.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct ChatItem: Codable {
    let id: String
    let classItemID: String
    let sellerID: String
    let buyerID: String
    let messages: [Message]?
    
    init(id: String = UUID().uuidString,
         classItemID: String,
         sellerID: String,
         buyerID: String,
         messages: [Message]?
    ) {
        self.id = id
        self.classItemID = classItemID
        self.sellerID = sellerID
        self.buyerID = buyerID
        self.messages = messages
    }
}

struct Message: Codable {
    let senderID: String
    let body: String
    let date: Date
}
