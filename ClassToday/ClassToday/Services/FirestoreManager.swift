//
//  FirestoreManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    static let shared = FirestoreManager()

    private init() {}

    // - MARK: CRUD Method

    func upload(classItem: ClassItem) {
        do {
            try FirestoreRoute.classItem.ref.document(classItem.id).setData(from: classItem)
        } catch {
            debugPrint(error)
        }
    }

    func fetch(completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        data.append(classItem)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }

    func update(classItem: ClassItem) {
        upload(classItem: classItem)
    }
    
    
    //category
    func categorySort(category: String, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContains: category).getDocuments() { (querySnapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        data.append(classItem)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
    
    //star
    func starSort(starList: [String], completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("id", in: starList).getDocuments() { (querySnapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        data.append(classItem)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
}
