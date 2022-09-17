//
//  SceneDelegate.swift
//  ClassToday
//
//  Created by 박태현 on 2022/03/29.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController: UIViewController = TabbarController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        if let uid = UserDefaultsManager.shared.isLogin() {
            // 로그인을 했지만 필수 유저 정보가 없는 경우, 필수 정보 입력 화면을 띄운다
            FirestoreManager.shared.readUser(uid: uid) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    if user.location == nil {
                        let root = EssentialUserInfoInputViewController()
                        let essentialUserInfoInputViewController = UINavigationController(
                            rootViewController: root
                        )
                        essentialUserInfoInputViewController.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController?.present(
                            essentialUserInfoInputViewController,
                            animated: true
                        )
                    }
                case .failure(let error):
                    print("ERROR \(error.localizedDescription)👩🏻‍🦳")
                }
            }
        } else {
            // 로그인이 안되어있는 경우
            let root = LaunchSignInViewController()
            let launchSignInViewController = UINavigationController(rootViewController: root)
            launchSignInViewController.modalPresentationStyle = .fullScreen
            window?.rootViewController?.present(launchSignInViewController, animated: true)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            } else if let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance(),
                      naverLogin.isNaverThirdPartyLoginAppschemeURL(url) {
                naverLogin.receiveAccessToken(url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//        if LocationManager.shared.isLocationAuthorizationAllowed() == false {
//            if let vc = window?.visibleViewController {
//                vc.present(UIAlertController.locationAlert(), animated: true)
//            }
//        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

