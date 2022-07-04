//
//  Message.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/26.
//

import Foundation
import MessageKit
import UIKit

struct Message: MessageType {
    
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: Date
    let sender: SenderType
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageMediaItem(image: image)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var image: UIImage?
    var downloadURL: URL?
    
    init(content: String) {
        sender = Sender(senderId: "any_unique_id", displayName: "김민상")
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(content: String, senderId: String, displayName: String) {
        sender = Sender(senderId: senderId, displayName: displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(image: UIImage) {
        sender = Sender(senderId: "any_unique_id", displayName: "김민상")
        self.image = image
        sentDate = Date()
        content = ""
        id = nil
    }
    
}

extension Message: Comparable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}
