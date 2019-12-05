//
//  Message.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import RxSwift

protocol SCMessageType: AnyObject {
  
}

enum SCMessageStatus: Int {
    case timer = 0, sending = 1, sent = 2, seen = 3
}

enum SCMessageDataLoadingStaus {
    case initial, loading, done, failed
}

class SCMessage: SCMessageType {
    var id: Int
    var author: SCUser
    var createdAt: String
    var isDeleted: Bool = false
    var content: String
    var type: MessageType
    var status: BehaviorSubject<SCMessageStatus>
    var dataLoadingStatus: BehaviorSubject<SCMessageDataLoadingStaus>
    
    init(
        id: Int,
        createdAt: String,
        author: SCUser,
        content: String,
        type: MessageType,
        isDeleted: Bool = false,
        status: SCMessageStatus
    ) {
        self.id = id
        self.createdAt = createdAt
        self.isDeleted = isDeleted
        self.author = author
        self.content = content
        self.type = type
        self.status = BehaviorSubject(value: status)
        self.dataLoadingStatus = BehaviorSubject<SCMessageDataLoadingStaus>(value: .initial)
    }
    
    func loadDataIfNeeded() {
        if type == .image {
            self.dataLoadingStatus.onNext(.loading)
            loadImageUrlFromFirebase(path: content)
                .done { (url) in
                    self.content = url
                    self.dataLoadingStatus.onNext(.done)
            }.catch { (_) in
                self.dataLoadingStatus.onNext(.failed)
            }
        }
    }
}
