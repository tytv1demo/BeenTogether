//
//  MessageRepository.swift
//  Cupid
//
//  Created by Trần Tý on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

enum MessageType : String {
    case image = "IMAGE", video = "VIDEO", audio = "AUDIO", text = "TEXT"
}

protocol MessageRepository: AnyObject {
    func view(threadID: String) -> Promise<Bool>
    
    func sendMessage(type: MessageType, content: String) -> Promise<Bool>
}

class BaseMessageRepository: MessageRepository {
    
    var messageRemoteDataSource: MessageRemoteDataSource = BaseMessageRemoteDataSource()
    
    func view(threadID: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            seal.fulfill(true)
        }
    }
    
    func sendMessage(type: MessageType, content: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            messageRemoteDataSource
                .chat(type: type, content: content)
                .done { (_) in
                    seal.fulfill(true)
            }.catch(seal.reject)
        }
    }
}
