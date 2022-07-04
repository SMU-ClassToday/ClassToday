//
//  Channel.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import Foundation

// Channel.swift
struct Channel {
    var id: String?
    let classItem: ClassItem?
    
    init(id: String? = nil, classItem: ClassItem? = nil) {
        self.id = id
        self.classItem = classItem
    }
}

extension Channel: Comparable {
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        guard let lName = lhs.classItem?.writer.name else { return true }
        guard let rName = rhs.classItem?.writer.name else { return true }
        return lName < rName
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
}
