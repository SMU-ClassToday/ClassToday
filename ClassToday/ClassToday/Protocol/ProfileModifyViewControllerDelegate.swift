//
//  ProfileModifyViewControllerDelegate.swift
//  ClassToday
//
//  Created by yc on 2022/07/13.
//

import Foundation

protocol ProfileModifyViewControllerDelegate: AnyObject {
    /// 유저 정보 수정이 완료되면 호출되는 메서드
    func didFinishUpdateUserInfo()
}
