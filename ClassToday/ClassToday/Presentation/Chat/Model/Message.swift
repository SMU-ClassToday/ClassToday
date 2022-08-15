//
//  Message.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/26.
//

import Foundation
import MessageKit
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    var matchFlag: Bool?
    var validityFlag: Bool?
    var reviewFlag: Bool?
    
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
    
    init(image: UIImage, senderId: String, displayName: String) {
        sender = Sender(senderId: senderId, displayName: displayName)
        self.image = image
        sentDate = Date()
        content = ""
        id = nil
    }
    
    init(matchFlag: Bool = true, senderId: String, displayName: String) {
        sender = Sender(senderId: senderId, displayName: displayName)
        self.matchFlag = matchFlag
        sentDate = Date()
        content = "매칭 발송"
        id = nil
    }
    
    init(validityFlag: Bool = true, senderId: String, displayName: String) {
        sender = Sender(senderId: senderId, displayName: displayName)
        self.validityFlag = validityFlag
        sentDate = Date()
        content = "매칭 완료"
        id = nil
    }
    
    init(reviewFlag: Bool = true, senderId: String, displayName: String) {
        sender = Sender(senderId: senderId, displayName: displayName)
        self.reviewFlag = reviewFlag
        sentDate = Date()
        content = "리뷰 완료"
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderName = data["senderName"] as? String else { return nil }
        id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else if let matchFlag = data["matchFlag"] as? Bool {
            self.matchFlag = matchFlag
            downloadURL = nil
            content = "매칭 발송"
        } else if let validityFlag = data["validityFlag"] as? Bool {
            self.validityFlag = validityFlag
            downloadURL = nil
            content = "매칭 완료"
        } else if let reviewFlag = data["reviewFlag"] as? Bool {
            self.reviewFlag = reviewFlag
            downloadURL = nil
            content = "리뷰 완료"
        } else {
            return nil
        }
    }

}

extension Message: DatabaseRepresentation {
    var representation: [String : Any] {
        var representation: [String: Any] = [
            "created": sentDate,
            "senderId": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            representation["url"] = url.absoluteString
        } else if let matchFlag = matchFlag {
            representation["matchFlag"] = matchFlag
        } else if let validityFlag = validityFlag {
            representation["validityFlag"] = validityFlag
        } else if let reviewFlag = reviewFlag {
            representation["reviewFlag"] = reviewFlag
        } else {
            representation["content"] = content
        }
        
        return representation
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
