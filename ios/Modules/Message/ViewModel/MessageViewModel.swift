//
//  MessageViewModel.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

protocol MessageViewModelProtocol: NSObject {
    var messages: BehaviorSubject<[SCMessage]> { get set }
    
    var user: SCUser { get set }
    
    var messageRepository: MessageRepository { get set }
    
    func sendMessage(type: MessageType, content: String)
}

class MessageViewModel: NSObject, MessageViewModelProtocol {
    
    var messageRepository: MessageRepository
    
    var threadRef: DatabaseReference
    
    var messages: BehaviorSubject<[SCMessage]>
    
    var user: SCUser = SCUser(id: 1, name: "anh yeu", avatar: "")
    
    override init() {
        messages = BehaviorSubject<[SCMessage]>(value: [])
        messageRepository = BaseMessageRepository()
        threadRef = Database.database().reference(withPath: "message/1_0/messages")
        super.init()
        
        self.loadMessage()
        self.bindChildAddedEvent()
    }
    
    func loadMessage() {
        threadRef
            .queryOrdered(byChild: "timeStamp")
            .observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                guard let rawMessages: [String: Any] = snapshot.value as? [String: Any] else {
                    return
                }
                let messages = rawMessages.map { firbaseEntityToSCTextMessage(raw: $0.value) }
                self.messages.onNext(messages)
            })
    }
    
    func bindChildAddedEvent() {
        threadRef
            .queryLimited(toLast: 1)
            .observe(.childAdded) { [unowned self] (snapshot) in
                guard let rawMessage: NSDictionary = snapshot.value as? NSDictionary else {
                    return
                }
                let message = firbaseEntityToSCTextMessage(raw: rawMessage)
                self.appendMessage(message)
        }
    }
    
    func appendMessage(_ message: SCMessage) {
        guard var messages = try? self.messages.value() else {
            return
        }
        messages.append(message)
        self.messages.onNext(messages)
    }
    
    func sendMessage(type: MessageType, content: String) {
        messageRepository
            .sendMessage(type: type, content: content)
            .done { (success) in
                print(success)
        }.catch { (err) in
            print(err)
        }
    }
    
}

func firbaseEntityToSCTextMessage(raw: Any) -> SCMessage {
    let message = raw as! [String: Any]
    let id: Int =  Int(message["id"] as! String)!
    let author = SCUser(id: message["author"] as! Int, name: "test", avatar: "")
    let createAt: String = "message[] as! String"
    let body: String = message["content"] as! String
    let scMessage = SCTextMessage(id: id, createdAt: createAt, author: author, body: body)
    return scMessage
}
