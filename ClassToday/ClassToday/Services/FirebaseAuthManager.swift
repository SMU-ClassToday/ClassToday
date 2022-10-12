//
//  FirebaseAuthManager.swift
//  ClassToday
//
//  Created by yc on 2022/06/05.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    
    private let auth = Auth.auth()
    
    /// 회원가입 메서드
    ///
    /// FirebaseAuth에 회원가입이 완료되면 부여된 고유 아이디(UID)로 Firestore에 저장한다.
    ///
    /// - `user`: 회원가입 할 유저 정보
    /// - `password`: 비밀번호
    func signUp(
        user: User,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        auth.createUser(withEmail: user.email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                print("Auth 가입 성공👍")
                // 회원가입에 성공하면, Firestore에 유저 정보를 저장한다.
                var newUser = user
                newUser.id = result.user.uid
                FirestoreManager.shared.uploadUser(user: newUser) { result in
                    switch result {
                    case .success(_):
                        print("Firestore 저장 성공!👍")
                        completion(.success(newUser.id))
                        return
                    case .failure(let error):
                        print("Firestore 저장 실패ㅠ🐢")
                        completion(.failure(error))
                        return
                    }
                }
                return
            }
        }
    }
    
    /// 현재 로그인 된 유저의 고유 아이디(UID)를 반환하는 메서드
    ///
    /// - return 값이 `nil`이면 로그인이 안되어있는 상태
    func getUserID() -> String? {
        guard let userID = auth.currentUser?.uid else { print("로그인 안되어있음ㅠ🐢"); return nil }
        print("로그인 되어있음!!🌸")
        return userID
    }
    
    /// 로그인 메서드
    ///
    /// - `email`: 로그인 할 유저의 이메일
    /// - `password`: 로그인 할 유저의 비밀번호
    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result.user.uid))
                return
            }
        }
    }
    
    /// 로그아웃 메서드
    ///
    /// 로그아웃에 성공, 실패에 따라 ` Result<Void, Error>`를 반환한다
    @discardableResult
    func signOut() -> Result<Void, Error> {
        do {
            try auth.signOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
