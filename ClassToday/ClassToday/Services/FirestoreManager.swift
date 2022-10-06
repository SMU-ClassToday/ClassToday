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

    /// ClassItem을 업로드합니다.
    func upload(classItem: ClassItem, completion: @escaping () -> ()) {
        do {
            try FirestoreRoute.classItem.ref.document(classItem.id).setData(from: classItem) { error in
                if let err = error {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    completion()
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    /// 모든 ClassItem을 패칭합니다.
    func fetch(completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint(error)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        data.append(classItem)
                    } catch {
                        debugPrint("Decoding is failed")
                    }
                }
            }
            completion(data)
        }
    }
    
    /// ClassItem을 지역 기준으로 패칭합니다.
    ///
    /// - parameter location: 위치 좌표 값(Location)
    /// - parameter completion: 수업 아이템 패칭 결과 클로저
    func fetch(_ location: Location?, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        let provider = NaverMapAPIProvider()

        /// naver reversegeocode를 사용한 기준 지역 패칭
        provider.locationToKeyword(location: location) { result in
            switch result {
            case .success(let keyword):
                FirestoreRoute.classItem.ref.whereField("keywordLocation", isEqualTo: keyword).getDocuments() { (snapshot, error) in
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
                                debugPrint("Decoding is failed")
                            }
                        }
                    }
                    completion(data)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    /// ClassItem을 지역 기준으로 패칭합니다.
    ///
    /// - parameter keyword: 키워드 문자열(@@구)
    /// - parameter completion: 수업 아이템 패칭 결과 클로저
    func fetch(keyword: String, completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []

            FirestoreRoute.classItem.ref.whereField("keywordLocation", isEqualTo: keyword).getDocuments() { (snapshot, error) in
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
                            debugPrint("Decoding is failed")
                        }
                    }
                }
                completion(data)
            }
    }

    /// ClassItem을 직접 패칭합니다.
    func fetch(classItemID: String, completion: @escaping (ClassItem) -> ()) {
        FirestoreRoute.classItem.ref.document(classItemID).getDocument(as: ClassItem.self) { result in
            switch result {
            case .success(let classItem):
                completion(classItem)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    func fetch(classItemId: String, completion: @escaping (Result<ClassItem, Error>) -> ()) {
        FirestoreRoute.classItem.ref.document(classItemId).getDocument{ snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let snapshot = snapshot {
                do {
                    let classItem = try snapshot.data(as: ClassItem.self)
                    completion(.success(classItem))
                } catch {
                    completion(.failure(error))
                }
                return
            }
        }
    }
    
    /// ClassItem을 업데이트 합니다.
    func update(classItem: ClassItem, completion: @escaping () -> ()) {
        upload(classItem: classItem, completion: completion)
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
    ///
    /// - parameter keyword: 키워드 문자열(@@구)
    /// - parameter category: 카테고리
    /// - parameter completion: 수업 아이템 패칭 결과 클로저
    func categorySort(keyword: String, category: String, completion: @escaping ([ClassItem]) -> ()) {
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
                        if keyword == classItem.keywordLocation {
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
    
    /// Category 배열에 해당하는 ClassItem을 패칭합니다.
    ///
    /// - parameter keyword: 키워드 문자열(@@구)
    /// - parameter categories: 카테고리 배열
    /// - parameter completion: 수업 아이템 패칭 결과 클로저
    func categorySort(keyword: String, categories: [String], completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContainsAny: categories).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let classItem = try document.data(as: ClassItem.self)
                        if keyword == classItem.keywordLocation {
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
    
    /// Category 배열에 해당하는 ClassItem을 패칭합니다.
    ///
    /// - parameter categories: 카테고리 배열
    /// - parameter completion: 수업 아이템 패칭 결과 클로저
    func categorySort(categories: [String], completion: @escaping ([ClassItem]) -> ()) {
        var data: [ClassItem] = []
        FirestoreRoute.classItem.ref.whereField("subjects", arrayContainsAny: categories).getDocuments() { (snapshot, error) in
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
        for classItem in starList {
            FirestoreRoute.classItem.ref.whereField("id", isEqualTo: classItem).getDocuments() { (snapshot, error) in
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
    
    func fetchChannel(channels: [String], completion: @escaping ([Channel]) -> ()) {
        var data: [Channel] = []
        for channel in channels {
            FirestoreRoute.channel.ref.whereField("id", isEqualTo: channel).getDocuments() { (snapshot, error) in
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
    
    func uploadMatch(match: Match) {
        do {
            try FirestoreRoute.match.ref.document(match.id).setData(from: match)
        } catch {
            debugPrint(error)
        }
    }

    func fetchMatch(userId: String, completion: @escaping ([Match]) -> ()) {
        var data: [Match] = []
        FirestoreRoute.match.ref.whereField("seller", isEqualTo: userId).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let match = try document.data(as: Match.self)
                        data.append(match)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
    
    func fetchMatchBuy(userId: String, completion: @escaping ([Match]) -> ()) {
        var data: [Match] = []
        FirestoreRoute.match.ref.whereField("buyer", isEqualTo: userId).getDocuments() { (snapshot, error) in
            if let error = error {
                debugPrint("Error getting documents: \(error)")
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let match = try document.data(as: Match.self)
                        data.append(match)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(data)
        }
    }
}
