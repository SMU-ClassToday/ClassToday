//
//  UIAlertController+.swift
//  ClassToday
//
//  Created by Yescoach on 2022/08/11.
//

import UIKit

extension UIAlertController {
    /// 위치정보와 관련된 얼럿을 호출합니다.
    ///
    /// - 얼럿의 허용하기 버튼을 누르면, 앱의 설정화면으로 이동합니다.
    static func locationAlert() -> UIAlertController {
        let alert = UIAlertController(title: "위치정보 권한이 필요해요.",
                                      message: """
                                                클래스투데이를 이용하려면, 설정에서 위치정보 권한을 허용으로 변경해주세요.
                                                """,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let allowAction = UIAlertAction(title: "허용하기", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL) {
                 UIApplication.shared.open(settingURL, completionHandler: { (success) in
                     print("Settings opened: \(success)") // Prints true
                 })
             }
        }
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        return alert
    }
}
