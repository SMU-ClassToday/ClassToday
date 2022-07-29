//
//  Mocks.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/11.
//

import Foundation


func getMessagesMock(classItem: ClassItem) -> [Message] {
    return (0...5).map { _ in Message(content: classItem.description, senderId: classItem.writer.id, displayName: classItem.writer.name) }
}

let mockClassItem = ClassItem(id: "1", name: "세상에 이런일이", date: nil, time: nil, place: nil, location: nil, price: nil, priceUnit: .perHour, description: "어떻게 사람이름이", images: nil, subjects: nil, targets: nil, itemType: .sell, validity: true, writer: MockData.mockUser2, createdTime: Date(), modifiedTime: nil, match: nil)