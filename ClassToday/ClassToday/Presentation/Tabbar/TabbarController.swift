//
//  TabbarController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit

class TabbarController: UITabBarController {
    //+탭을 알럿을 모달하는 버튼으로 사용할때 필요한 flag
    var isUploadTabBarEnabled: Bool = true
    
    //MARK: - UI Components
    lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.view.tintColor = UIColor.mainColor

        let buyUploadAction = UIAlertAction(title: "구매글 작성", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.present(ClassEnrollViewController(classItemType: .buy), animated: true, completion: nil)
        }
        let sellUploadAction = UIAlertAction(title: "판매글 작성", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.present(ClassEnrollViewController(classItemType: .sell), animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [buyUploadAction, sellUploadAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        return alertController
    }()
    
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        tabBar.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: tabBar.layer.cornerRadius).cgPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        view.backgroundColor = .white
        view.tintColor = UIColor.mainColor
        delegate = self
        
        let viewControllerList: [UIViewController] = Tabbar.allCases.map {
            let viewController = $0.viewController
            viewController.tabBarItem = $0.tabBarItem
            return viewController
        }
        
        viewControllers = viewControllerList
    }
}

//MARK: - tabbarcontroller delegate
extension TabbarController: UITabBarControllerDelegate {
    //+탭 선택시 얼럿을 표시
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.image == Icon.plus.image {
            present(alertController, animated: true)
            isUploadTabBarEnabled = false
        } else {
            isUploadTabBarEnabled = true
        }
        // 로그인 여부 확인
        if item.image == Icon.person.image { checkUser() }
    }
    
    //+탭 선택시 뷰컨 보여주지 않음
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return isUploadTabBarEnabled
    }
}

// MARK: - LaunchSignInViewControllerDelegate
extension TabbarController: LaunchSignInViewControllerDelegate {
    func didTapDismissButton() {
        print("didTapDismissButton")
        selectedIndex = 0
    }
}

// MARK: - 로그인 여부 메서드
private extension TabbarController {
    func checkUser() {
        if FirebaseAuthManager.shared.getUserID() == nil {
            let rootVC = LaunchSignInViewController()
            rootVC.delegate = self
            let launchSignInVC = UINavigationController(rootViewController: rootVC)
            launchSignInVC.modalPresentationStyle = .fullScreen
            present(launchSignInVC, animated: true)
        }
    }
}
