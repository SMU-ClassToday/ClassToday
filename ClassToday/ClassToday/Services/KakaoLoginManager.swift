//
//  KakaoLoginManager.swift
//  ClassToday
//
//  Created by 박태현 on 2022/09/14.
//

import Foundation
import Alamofire
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

enum KakaoLoginStatus {
    case signUp
    case signIn
}

class KakaoLoginManager {
    static let shared = KakaoLoginManager()
    
    func login(_ completion: @escaping (Result<(KakaoLoginStatus, String), Error>) -> Void) {
        /// 토큰이 있을 경우
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { [weak self] (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        /// 로그인 필요
                        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                            if let error = error {
                                print(error)
                                completion(.failure(error))
                            } else {
                                print("Kakao Login")
                                
                                //do something
                                _ = oauthToken
                                // 어세스토큰
                                let accessToken = oauthToken?.accessToken
                                
                                // 로그인 성공 시
                                self?.loginOrSignUp { result in
                                    completion(result)
                                }
                            }
                        }
                    } else {
                        //기타 에러
                        print(error)
                        completion(.failure(error))
                    }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self?.loginOrSignUp { result in
                        completion(result)
                    }
                }
            }
        } else {
            /// 토큰이 없는 경우
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                    if let error = error {
                        print(error)
                        completion(.failure(error))
                    } else {
                        print("New Kakao Login")
                        
                        //do something
                        _ = oauthToken
                        
                        // 로그인 성공 시
                        self?.loginOrSignUp { result in
                            completion(result)
                        }
                    }
                }
            }
        }
    }
    
    /// 카카오톡 계정을 로그아웃 합니다. 토큰이 모두 만료됩니다.
    func logout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    /// 사용자 액세스 토큰 정보를 조회합니다.
    func getAccessTokenInfo(_ completion: @escaping (Result<AccessTokenInfo, Error>) -> Void) {
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
            } else {
                print("accessTokenInfo() success.")
                completion(.success(accessTokenInfo!))
            }
        }
    }
    
    private func loginOrSignUp(_ completion: @escaping (Result<(KakaoLoginStatus, String), Error>) -> Void) {
        // 로그인 성공 시
        UserApi.shared.me { kuser, error in
            if let error = error {
                print("------KAKAO : user loading failed------")
                completion(.failure(error))
            } else {
                guard let kakaoEmail = kuser?.kakaoAccount?.email else { return }
                let email = kakaoEmail + ".kakao"
                let password = String(describing: kuser?.id)
                let user = User(
                    name: "",
                    nickName: "",
                    gender: "",
                    location: nil,
                    detailLocation: nil,
                    keywordLocation: nil,
                    email: email,
                    profileImage: nil,
                    company: nil,
                    description: nil,
                    stars: nil,
                    subjects: nil,
                    channels: nil
                )
                // 회원가입
                FirebaseAuthManager.shared.signUp(user: user, password: password) { result in
                    switch result {
                    case .success(let uid):
                        print("회원가입 성공!🎉")
                        UserDefaultsManager.shared.saveLoginStatus(uid: uid, type: .kakao)
                        completion(.success((.signUp, uid)))
                    case .failure(let error):
                        print("회원가입 실패 ㅠ \(error.localizedDescription)🐢")

                        // 로그인 진행
                        FirebaseAuthManager.shared.signIn(email: kakaoEmail, password: password) { result in
                            switch result {
                            case .success(let uid):
                                print("로그인 성공🐹")
                                print(uid, "🥵")
                                UserDefaultsManager.shared.saveLoginStatus(uid: uid, type: .kakao)
                                completion(.success((.signIn, uid)))
                            case .failure(let error):
                                print("\(error.localizedDescription)🐸🐸")
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
}

