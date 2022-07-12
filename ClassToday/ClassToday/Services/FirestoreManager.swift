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
    private var currentLocation: Location? = LocationManager.shared.getCurrentLocation()
    private var currentLocality: String? = ""
    // - MARK: CRUD Method

    
    func upload(classItem: ClassItem) {
        do {
            try FirestoreRoute.classItem.ref.document(classItem.id).setData(from: classItem)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetch(currentLocation: Location, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        DispatchQueue.global().sync {
            LocationManager.shared.getLocalityOfAddress(of: currentLocation) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let locality):
                    self.currentLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.currentLocality = ""
                }
            }
        }
        FirestoreRoute.classItem.ref.getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        print(self.currentLocality)
                        if self.currentLocality == classItem.locality {
                            data.append(classItem)
                        }
                    } catch {
                        
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
        DispatchQueue.global().sync {
            LocationManager.shared.getLocalityOfAddress(of: currentLocation) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let locality):
                    self.currentLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.currentLocality = ""
                }
            }
        }
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContains: category).getDocuments() { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if self.currentLocality == classItem.locality {
                            data.append(classItem)
                        }
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
        DispatchQueue.global().sync {
            LocationManager.shared.getLocalityOfAddress(of: currentLocation) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let locality):
                    self.currentLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.currentLocality = ""
                }
            }
        }
        FirestoreRoute.classItem.ref.whereField("id", in: starList).getDocuments() { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if self.currentLocality == classItem.locality {
                            data.append(classItem)
                        }
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
