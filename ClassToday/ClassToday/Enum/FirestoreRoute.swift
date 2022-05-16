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

    var ref: CollectionReference {
        switch self {
        case .classItem :
            return FirestoreManager.singleton.db.collection("ClassItem")
        }
    }
}
