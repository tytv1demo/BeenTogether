//
//  MessageApi.swift
//  Cupid
//
//  Created by Trần Tý on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Moya
import UIKit

enum MessageApi {
    case view
    case chat(type: String, content: String)
    case sendImage(data: Data)
}

extension MessageApi: AuthorizedTargetType {
    
    public var needsAuth: Bool {
        return true
    }
    
    var baseURL: URL {
        return URL(string: "\(APIEndpoint.baseURL.rawValue  )/message")!
    }
    
    var path: String {
        switch self {
        case .chat:
            return "chat"
        case .sendImage:
            return "send-image"
        case .view:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .chat:
            return .post
        case .sendImage:
            return .post
        case .view:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .chat(let type, let content):
            let body: [String: String] = ["type": type, "content": content]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        case .sendImage(let data):
            let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "m.jpg", mimeType: "image/jpeg")
            let multipartData = [imageData]

            return .uploadMultipart(multipartData)
        case .view:
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    
    
}
