//
//  UserAPI.swift
//  Cupid
//
//  Created by Dung Nguyen on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya

public struct SignInParams {
    var phoneNumber: String
    var firebaseToken: [String: String]
}

public struct SignUpParams {
    var phoneNumber: String
    var name: String?
    var firebaseToken: [String: String]
}

public enum UserAPI {
    case signIn(userParams: SignInParams)
    case signUp(signUpParams: SignUpParams)
    case logout
    case getUserProfile
    case updateDeviceToken(token: String)
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
        case .updateDeviceToken:
            return "/user/device-token"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signIn, .updateDeviceToken:
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
            params["firebaseToken"] = userParams.firebaseToken
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .signUp(signUpParams):
            var params = [String: Any]()
            params["phoneNumber"] = signUpParams.phoneNumber
            params["name"] = signUpParams.name
            params["firebaseToken"] = signUpParams.firebaseToken
            params["age"] = 0
            params["gender"] = "MALE"
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        case .getUserProfile:
            return .requestPlain
        case .updateDeviceToken(let token):
            var params = [String: Any]()
            params["token"] = token
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}
