//
//  ChatStreamManager.swift
//  ClassToday
//
//  Created by poohyhy on 2022/08/01.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatStreamManager {
    static let shared = ChatStreamManager()
    private init() {}
    var collectionListener: CollectionReference?
    var listener: ListenerRegistration?
    
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
    
    func removeListener() {
        listener?.remove()
    }
}
