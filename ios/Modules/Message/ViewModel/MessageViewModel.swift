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
import PromiseKit

protocol MessageViewModelDelegate: AnyObject {
    func messageViewModel(didLoadMessages viewModel: MessageViewModelProtocol, messages: [SCMessage])
    
    func messageViewModel(didAddMessage viewModel: MessageViewModelProtocol, message: SCMessage)
}

protocol MessageViewModelProtocol: NSObject {
    
    var delegate: MessageViewModelDelegate? { get set }
    
    var messages: BehaviorSubject<[SCMessage]> { get set }
    
    var user: SCUser { get set }
    
    var coupleModel: CoupleModel { get set }
    
    var viewData: BehaviorSubject<MessageViewData> { get set }
    
    var messageRepository: MessageRepository { get set }
    
    func sendMessage(type: MessageType, content: String)
    
    func sendImage(data: Data)
}

struct MessageViewData {
    var loverName: String
    
    var loverAvatar: String
}

class MessageViewModel: NSObject, MessageViewModelProtocol {
    
    weak var delegate: MessageViewModelDelegate?
    
    var messageRepository: MessageRepository
    
    var threadRef: DatabaseReference
    
    var messages: BehaviorSubject<[SCMessage]>
    
    var user: SCUser
    
    var coupleModel: CoupleModel
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var viewData: BehaviorSubject<MessageViewData> = BehaviorSubject(value: MessageViewData(loverName: "", loverAvatar: ""))
    
    init(userInfo: User = AppUserData.shared.userInfo, coupleModel: CoupleModel? = nil) {
        user = SCUser(id: userInfo.id, name: userInfo.name, avatar: "")
        messages = BehaviorSubject<[SCMessage]>(value: [])
        messageRepository = BaseMessageRepository()
        let coupleId = userInfo.coupleId
        threadRef = Database.database().reference(withPath: "message/\(coupleId)/messages")
        self.coupleModel = coupleModel ?? CoupleModel(userInfo: AppUserData.shared.userInfo)
        super.init()
        
        self.loadMessage()
        self.bindChildAddedEvent()
        subscribeCoupleModel()
    }
    
    func loadMessage() {
        threadRef
            .queryOrdered(byChild: "timeStamp")
            .queryLimited(toLast: 100)
            .observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                let messages = snapshot
                    .children
                    .map({ firbaseEntityToSCTextMessage(raw: ($0 as! DataSnapshot).value!)})
                messages.forEach { $0.loadDataIfNeeded() }
                self.messages.onNext(messages)
                self.delegate?.messageViewModel(didLoadMessages: self, messages: messages)
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
                
                if message.author.id == self.user.id {
                    return
                }
                self.appendMessage(message)
        }
    }
    
    func appendMessage(_ message: SCMessage) {
        guard var messages = try? self.messages.value() else {
            return
        }
        message.author.avatar = try? coupleModel.friendConfig.value()?.avatar
        messages.append(message)
        message.loadDataIfNeeded()
        delegate?.messageViewModel(didAddMessage: self, message: message)
        self.messages.onNext(messages)
    }
    
    func sendMessage(type: MessageType, content: String) {
        let message: SCMessage = self.createMessage(type: type, content: content)
        self.appendMessage(message)
        messageRepository
            .sendText(content: content)
            .done { (sendMessage) in
                message.content = sendMessage.content
                message.status.onNext(.sent)
        }.catch { (err) in
            print(err)
        }
    }
    
    func sendImage(data: Data) {
        let message: SCMessage = self.createMessage(type: .image, content: "")
        self.appendMessage(message)
        messageRepository
            .sendImage(data: data)
            .done { (remoteMessage) in
                message.content = remoteMessage.content
                message.status.onNext(.sent)
                message.loadDataIfNeeded()
        }.catch { (err) in
            print(err)
        }
    }
    
    func createMessage(type: MessageType, content: String) -> SCMessage {
        let message: SCMessage = SCMessage(id: -1, createdAt: "test", author: user, content: content, type: type, status: .sending)
        return message
    }
    
    func subscribeCoupleModel() {
        coupleModel.friendConfig.subscribe(onNext: { (config) in
            guard let friendConfig = config else { return }
            self.updateViewData(friendConfig: friendConfig)
        }).disposed(by: disposeBag)
    }
    
    func updateViewData(friendConfig: Config) {
        guard var viewData = try? viewData.value() else { return }
        viewData.loverName = friendConfig.name
        viewData.loverAvatar = friendConfig.avatar
        self.viewData.onNext(viewData)
    }
}

func firbaseEntityToSCTextMessage(raw: Any) -> SCMessage {
    let message = raw as! [String: Any]
    let id: Int =  Int(message["id"] as! String)!
    let author = SCUser(id: message["author"] as! Int, name: "test", avatar: "")
    let createAt: String = "message[] as! String"
    let body: String = message["content"] as! String
    let type: MessageType = MessageType(rawValue: message["type"] as! String)!
    let scMessage = SCMessage(id: id, createdAt: createAt, author: author, content: body, type: type, status: .sent)
    return scMessage
}

func loadImageUrlFromFirebase(path: String) -> Promise<String> {
    return Promise<String> {seal in
        Database.database()
            .reference(withPath: path)
            .observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as! [String: String]
                seal.fulfill(value["image"]!)
        }
    }
}
