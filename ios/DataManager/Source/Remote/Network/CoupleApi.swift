//
//  CoupleApi.swift
//  Cupid
//
//  Created by Trần Tý on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya

enum MatchRequestAction: String {
    case accept, reject
}

enum CoupleApi {
    case responseMatchRequest(fromUserId: Int, action: MatchRequestAction)
    case getNewestCoupleMatchRequest
}

extension CoupleApi: AuthorizedTargetType {
    
    public var needsAuth: Bool {
        return true
    }
    
    var baseURL: URL {
        return URL(string: "\(APIEndpoint.baseURL.rawValue)/couple")!
    }
    
    var path: String {
        switch self {
        case .getNewestCoupleMatchRequest:
            return "/get-match-request"
        case .responseMatchRequest:
            return "/response-match-request"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNewestCoupleMatchRequest:
            return .get
        case .responseMatchRequest:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .getNewestCoupleMatchRequest:
            return .requestPlain
        case .responseMatchRequest(let fromId, let action):
            let params: [String: Any] = ["fromUserId": fromId, "action": action.rawValue]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
    
}
