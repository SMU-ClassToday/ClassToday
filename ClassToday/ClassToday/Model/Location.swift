//
//  Location.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/15.
//

import Foundation

struct Location: Codable {
    let lat: Double
    let lon: Double
    
    var name: String { "인천 미추홀구 용현5동" }
}
