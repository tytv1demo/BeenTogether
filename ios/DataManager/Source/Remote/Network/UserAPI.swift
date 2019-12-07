//
//  UserAPI.swift
//  Cupid
//
//  Created by Dung Nguyen on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya

public struct UserParams {
    var phoneNumber: String?
    var accessToken: String?
}

public enum UserAPI {
    case signIn(userParams: UserParams)
    case signUp
    case logout
    case getUserProfile(phoneNumber: String)
}

extension UserAPI: AuthorizedTargetType {
    
    public var needsAuth: Bool {
        return true
    }
    
    public var baseURL: URL {
        return URL(string: APIEndpoint.baseURL.rawValue)!
    }
    
    public var path: String {
        switch self {
        case .signIn:
            return "user/auth/sign-in"
        case .signUp:
            return "user/auth/sign-up"
        case .logout:
            return "/logout"
        case .getUserProfile:
            return "/user/profile"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        case .logout:
            return .post
        case .getUserProfile:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "".utf8Encoded
    }
    
    public var task: Moya.Task {
        switch self {
        case let .signIn(userParams):
            var params = [String: Any]()
            params["phoneNumber"] = userParams.phoneNumber
            params["accessToken"] = userParams.accessToken
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .signUp:
            return .requestPlain
        case .logout:
            return .requestPlain
        case .getUserProfile(let phoneNumber):
            let query = ["phoneNumber": phoneNumber]
            return .requestParameters(parameters: query, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}
