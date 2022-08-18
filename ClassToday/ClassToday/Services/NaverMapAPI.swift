//
//  NaverMapAPI.swift
//  ClassToday
//
//  Created by 박태현 on 2022/07/31.
//

import Foundation
import Alamofire
import Moya

enum NaverMapAPI {
    case reverseGeocoding(_ lat: Double, _ lon: Double)
}

extension NaverMapAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://naveropenapi.apigw.ntruss.com")!
    }

    var path: String {
        switch self {
        case .reverseGeocoding(_, _):
            return "/map-reversegeocode/v2/gc"
        }
    }

    var method: Moya.Method {
        switch self {
        case .reverseGeocoding(_, _):
            return .get
        }
    }

    var task: Task {
        switch self {
        case .reverseGeocoding(let lat, let lon):
            let coords: [String] = [String(lon), String(lat)]
            let params: [String: String] = [
                "request": "coordsToaddr",
                "coords": (coords as AnyObject).componentsJoined(by: ","),
                "orders": "roadaddr",
                "output": "json"
            ]
            return .requestParameters(parameters: params, encoding: CustomUrlEncoding())
        }
    }

    var headers: [String : String]? {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError()
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let id = plist?.object(forKey: "NMFClientId") as? String, let key = plist?.object(forKey: "NMFClientSecret") as? String else {
            fatalError()
        }
        return [
            "X-NCP-APIGW-API-KEY-ID": id,
            "X-NCP-APIGW-API-KEY": key,
            "Content-type": "application/json"
        ]
    }
}

struct CustomUrlEncoding : ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }

            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters: parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }

        return urlRequest
    }

    private func query(parameters: Parameters) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let array = value as? [Any] {
            components.append((key, encode(array: array, separatedBy: ",")))
        } else {
            components.append((key, "\(value)"))
        }

        return components
    }

    private func encode(array: [Any], separatedBy separator: String) -> String {
        return array.map({"\($0)"}).joined(separator: separator)
    }
}
