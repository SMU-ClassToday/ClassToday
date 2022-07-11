//
//  FirestoreRoute.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/16.
//

import Foundation
import FirebaseFirestore

enum FirestoreRoute {
    case classItem
    case user
    case channel

    static var db = Firestore.firestore()

    var ref: CollectionReference {
        switch self {
        case .classItem:
            return Self.db.collection("ClassItem")
        case .user:
            return Self.db.collection("User")
        case .channel:
            return Self.db.collection("channel")
        }
    }
}
