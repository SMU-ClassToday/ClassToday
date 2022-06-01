//
//  Setting.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import Foundation

enum Setting: String, CaseIterable {
    case account = "계정 관리"
    case blockUser = "차단 사용자 관리"
    case alarm = "알림 설정"
    case cache = "캐시 데이터 관리"
    case logout = "로그아웃"
    case resign = "탈퇴하기"
    case termsOfService = "이용약관"
    
    var text: String { self.rawValue }
}
