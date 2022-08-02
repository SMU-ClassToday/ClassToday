//
//  NaverMapAddress.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/31.
//

import Foundation

struct NaverMapAddress: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
    let addition0: Addition
}

struct Code: Codable {
    let id: String
    let type: String
    let mappingID: String
}

struct Region: Codable {
    let area1: Area
    let area2: Area
    let area3: Area
    let area4: Area
}

struct Area: Codable {
    let name: String
}

struct Land: Codable {
    let name: String
    let number1: String
    let number2: String
}

struct Addition: Codable {
    let type: String
    let value: String
}
