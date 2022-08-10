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
    private var targetLocality: String? = ""

    // - MARK: CRUD Method

    /// ClassItem을 업로드합니다.
    func upload(classItem: ClassItem) {
        do {
            try FirestoreRoute.classItem.ref.document(classItem.id).setData(from: classItem)
        } catch {
            debugPrint(error)
        }
    }
    
    /// ClassItem을 지역 기준으로 패칭합니다.
    /// 기준 값: locality
    func fetch(_ location: Location?, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        DispatchQueue.global().sync { [weak self] in
            guard let self = self else { return }
            LocationManager.shared.getKeywordOfLocation(of: location) { result in
                switch result {
                case .success(let locality):
                    self.targetLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.targetLocality = ""
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
                        if self.targetLocality == classItem.keywordLocation {
                            data.append(classItem)
                        }
                    } catch {
                        
                    }
                }
            }
            completion(data)
        }
    }

    /// ClassItem을 직접 패칭합니다.
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
    
    /// ClassItem을 업데이트 합니다.
    func update(classItem: ClassItem) {
        upload(classItem: classItem)
    }
    
    /// ClassItem을 삭제합니다.
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
    /// Category에 해당하는 ClassItem을 패칭합니다.
    func categorySort(location: Location, category: String, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        DispatchQueue.global().sync {
            LocationManager.shared.getKeywordOfLocation(of: location) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let locality):
                    self.targetLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.targetLocality = ""
                }
            }
        }
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContains: category).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if self.targetLocality == classItem.keywordLocation {
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
    
    func categorySort(location: Location, categories: [String], completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        DispatchQueue.global().sync {
            LocationManager.shared.getKeywordOfLocation(of: location) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let locality):
                    self.targetLocality = locality
                case .failure(let error):
                    debugPrint(error)
                    self.targetLocality = ""
                }
            }
        }
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContainsAny: categories).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if self.targetLocality == classItem.keywordLocation {
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
        FirestoreRoute.classItem.ref.whereField("id", in: starList).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if self.targetLocality == classItem.keywordLocation {
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
