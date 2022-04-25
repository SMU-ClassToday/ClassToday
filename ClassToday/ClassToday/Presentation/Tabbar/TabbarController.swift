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
        
        let buyUploadAction = UIAlertAction(title: "구매글 작성", style: .default, handler: nil)
        let sellUploadAction = UIAlertAction(title: "판매글 작성", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [buyUploadAction, sellUploadAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        return alertController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension TabbarController: UITabBarControllerDelegate {
    //+탭 선택시 얼럿을 표시
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.image == Icon.plus.image {
            present(alertController, animated: true)
            isUploadTabBarEnabled = false
        } else {
            isUploadTabBarEnabled = true
        }
    }
    
    //+탭 선택시 뷰컨 보여주지 않음
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return isUploadTabBarEnabled
    }
}


// MARK: - MapVc
class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
// MARK: - ChatVC
class ChatViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
// MARK: - ProfileVC
class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
