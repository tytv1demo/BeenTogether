//
//  APIConfig.swift
//  Cupid
//
//  Created by Trần Tý on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya

public protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

// CoinMarketCap
struct AuthPlugin: PluginType {
    
    let headerField: String!
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let token = self.tokenClosure(),
            let multiTarget = target as? MultiTarget,
            let target = multiTarget.target as? AuthorizedTargetType,
            target.needsAuth else {
                return request
        }
        var request = request
        request.addValue(token, forHTTPHeaderField: self.headerField)
        return request
    }
    
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

private func outputPrint(_ separator: String, terminator: String, items: Any...) {
    #if DEBUG
    for item in items {
        print(item, separator: separator, terminator: terminator)
    }
    #endif
}

let todoProvider = MoyaProvider<MultiTarget>(plugins: [
    NetworkLoggerPlugin(verbose: false, cURL: true, output: outputPrint, responseDataFormatter: JSONResponseDataFormatter),
    AuthPlugin(headerField: JSONKey.authorization.rawValue,
               tokenClosure: { return AppUserData.shared.userToken })
])

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

enum APIEndpoint: String {
//    case baseURL = "https://cupid-api.tranty9597.now.sh"
     case baseURL = "http://172.16.1.14:3000"
}

enum JSONKey: String {
    case authorization
}
