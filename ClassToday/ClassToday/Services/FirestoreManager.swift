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
    var collectionListener: CollectionReference?
    var listener: ListenerRegistration?
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
    
    func fetch(classItem: ClassItem, completion: @escaping (ClassItem) -> ()) {
        FirestoreRoute.classItem.ref.document(classItem.id).getDocument(as: ClassItem.self) { result in
            switch result {
            case .success(let classItem):
                completion(classItem)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    func update(classItem: ClassItem) {
        upload(classItem: classItem)
    }

    func delete(classItem: ClassItem) {
        FirestoreRoute.classItem.ref.document(classItem.id).delete { error in
            if let error = error {
                debugPrint("Error removing document: \(error)")
            } else {
                debugPrint("Document successfully removed!")
            }
        }
    }

    //category
    func categorySort(category: String, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContains: category).getDocuments() { (snapshot, error) in
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

    //star
    func starSort(starList: [String], completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("id", in: starList).getDocuments() { (snapshot, error) in
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
}

// MARK: - User 관련 Firestore 메서드
extension FirestoreManager {
    /// 유저 정보를 저장하는 메서드
    ///
    /// - `user`: 저장할 유저
    func uploadUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try FirestoreRoute.user.ref.document(user.id).setData(from: user)
            completion(.success(()))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    /// 유저 정보를 가져오는 메서드
    ///
    /// - `uid`: 찾을 유저 고유의 아이디 (UID)
    func readUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        FirestoreRoute.user.ref.document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let snapshot = snapshot {
                do {
                    let user = try snapshot.data(as: User.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
                return
            }
        }
    }
}

//MARK: - chat 관련 Firestore Method
extension FirestoreManager {
    func uploadChannel(channel: Channel) {
        do {
            try FirestoreRoute.channel.ref.document(channel.id).setData(from: channel)
        } catch {
            debugPrint(error)
        }
    }
    
    func delete(channel: Channel) {
        FirestoreRoute.channel.ref.document(channel.id).delete { error in
            if let error = error {
                debugPrint("Error removing document: \(error)")
            } else {
                debugPrint("Document successfully removed!")
            }
        }
    }
    
    func update(channel: Channel) {
        uploadChannel(channel: channel)
    }
    
    func checkChannel(sellerID: String, buyerID: String, classItemID: String, completion: @escaping ([Channel]) -> ()) {
        var data: [Channel] = []
        FirestoreRoute.channel.ref.whereField("sellerID", isEqualTo: sellerID).whereField("buyerID", isEqualTo: buyerID).whereField("classItemID", isEqualTo: classItemID).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let channel = try document.data(as: Channel.self)
                        data.append(channel)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
    
    func fetchChannel1(currentUserID: String, completion: @escaping ([Channel]) -> ()) {
        var data: [Channel] = []
        FirestoreRoute.channel.ref.whereField("sellerID", isEqualTo: currentUserID).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let channel = try document.data(as: Channel.self)
                        data.append(channel)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
    
    func fetchChannel2(currentUserID: String, completion: @escaping ([Channel]) -> ()) {
        var data: [Channel] = []
        FirestoreRoute.channel.ref.whereField("buyerID", isEqualTo: currentUserID).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let channel = try document.data(as: Channel.self)
                        data.append(channel)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
    
    
    func subscribe(id: String, completion: @escaping (Result<[Message], StreamError>) -> Void) {
        let streamPath = "channel/\(id)/thread"
        
        removeListener()
        collectionListener = FirestoreRoute.db.collection(streamPath)
        
        listener = collectionListener?
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    completion(.failure(StreamError.firestoreError(error)))
                    return
                }
                
                var messages = [Message]()
                snapshot.documentChanges.forEach { change in
                    if let message = Message(document: change.document) {
                        if case .added = change.type {
                            messages.append(message)
                        }
                    }
                }
                completion(.success(messages))
            }
    }
    
    func save(_ message: Message, completion: ((Error?) -> Void)? = nil) {
        collectionListener?.addDocument(data: message.representation) { error in
            completion?(error)
        }
    }
    
    func fetch(channel: Channel, completion: @escaping (Channel) -> ()) {
        FirestoreRoute.channel.ref.document(channel.id).getDocument(as: Channel.self) { result in
            switch result {
            case .success(let channel):
                completion(channel)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
