//
//  NaverMapAddress.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/31.
//

import Foundation

struct NaverMapAddress: Codable {
//    let status: Status
    let results: [AddrAPIResult]
}

struct Status: Codable {
    let code: Int
    let name: String
    let message: String
}

struct AddrAPIResult: Codable {
    let name: String
    let code: AddrAPIResult.Code
    let region: AddrAPIResult.Region
    let land: Land

    struct Code: Codable {
        let id: String
        let type: String
        let mappingId: String
    }
    
    struct Region: Codable {
        let area1: Area
        let area2: Area
        let area3: Area
        let area4: Area
    }
}

struct Area: Codable {
    let name: String?
}

struct Land: Codable {
    let name: String?
    let number1: String?
    let addition0: Land.Addition

    struct Addition: Codable {
        let type: String?
        let value: String?
    }
}
