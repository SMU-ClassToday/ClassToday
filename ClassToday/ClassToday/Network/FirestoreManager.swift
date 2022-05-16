//
//  FirestoreManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
    static let singleton = FirestoreManager()

    private let db = Firestore.firestore()

    private init() {}

    func upload(classItem: ClassItem) {
        do {
            try db.collection("ClassItem").document(classItem.id).setData(from: classItem)
        } catch {
            debugPrint(error)
        }
    }
}
