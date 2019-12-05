//
//  MessageRepository.swift
//  Cupid
//
//  Created by Trần Tý on 11/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

enum MessageType: String {
    case image = "IMAGE", video = "VIDEO", audio = "AUDIO", text = "TEXT"
}

protocol MessageRepository: AnyObject {
    func view(threadID: String) -> Promise<Bool>
    
    func sendText(content: String) -> Promise<RemoteMessage>
    
    func sendImage(data: Data) -> Promise<RemoteMessage>
}

class BaseMessageRepository: MessageRepository {
    
    var messageRemoteDataSource: MessageRemoteDataSource = BaseMessageRemoteDataSource()
    
    func view(threadID: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            seal.fulfill(true)
        }
    }
    
    func sendText(content: String) -> Promise<RemoteMessage> {
        return Promise<RemoteMessage> { seal in
            messageRemoteDataSource
                .sendText(content: content)
                .done { (message) in
                    seal.fulfill(message)
            }.catch(seal.reject)
        }
    }
    
    func sendImage(data: Data) -> Promise<RemoteMessage> {
        return Promise<RemoteMessage> { seal in
            messageRemoteDataSource
                .sendImage(data: data)
                .done { (message) in
                    seal.fulfill(message)
            }.catch(seal.reject)
        }
    }
}
