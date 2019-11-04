//
//  MessageViewModel.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageViewModelProtocol: AnyObject {
    var messages: Array<SCMessage> { get set }
    var user: SCUser { get set }
}

class MessageViewModel: MessageViewModelProtocol {

    var messages: Array<SCMessage> = []
    var user: SCUser = SCUser(id: 1, name: "anh yeu", avatar: "")
    init() {
      let tuser: SCUser = SCUser(id: 2, name: "em yeu", avatar: "")
      messages = [
        SCTextMessage(id: 1, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 2, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 3, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 4, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 5, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 1, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 2, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 3, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 4, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 5, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 1, createdAt: "fdsafdsaf", author: user, body: "dfasdf,dfasdfdfasdf dasf asdfsdaf asd asdf as sadf sadf asdf"),
        SCTextMessage(id: 2, createdAt: "fdsafdsaf", author: user, body: "dfasdf"),
        SCTextMessage(id: 3, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 4, createdAt: "fdsafdsaf", author: tuser, body: "dfasdf"),
        SCTextMessage(id: 5, createdAt: "fdsafdsaf", author: user, body: "dfasdf")
      ]
    }
    
}
