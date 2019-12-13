//
//  Message.swift
//  Cupid
//
//  Created by Trần Tý on 12/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct RemoteMessage {
    var id: String
    var author: Int
    var type: MessageType = .text
    var content: String
    var timeStamp: String
}

extension RemoteMessage: Decodable {
    enum RemoteMessageKeys: String, CodingKey {
        case id, author, type, content, timeStamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RemoteMessageKeys.self)
        id = try container.decode(String.self, forKey: .id)
        author = try container.decode(Int.self, forKey: .author)
        content = try container.decode(String.self, forKey: .content)
//        timeStamp = try container.decode(String.self, forKey: .timeStamp)
        timeStamp = ""
        
    }
}

struct BaseResult<T: Decodable>: Decodable {
    enum BaseResultKeys: String, CodingKey {
        case data, message
    }
    var data: T
    var message: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseResultKeys.self)
        data = try container.decode(T.self, forKey: .data)
        message = try? container.decode(String.self, forKey: .message)
    }
}
