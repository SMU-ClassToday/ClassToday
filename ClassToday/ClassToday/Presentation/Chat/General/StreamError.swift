//
//  StreamError.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/12.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
