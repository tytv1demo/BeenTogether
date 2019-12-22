//
//  Message.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

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
    
    var image: UIImage?
    
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
        let status = try? self.status.value()
        if type == .image, status == .sent {
            self.dataLoadingStatus.onNext(.loading)
            loadImageUrlFromFirebase(path: content)
                .done { [unowned self] (url) in
                    self.content = url
                    self.loadImage()
            }.catch { (_) in
                self.dataLoadingStatus.onNext(.failed)
            }
        }
    }
    
    func loadImage() {
        guard let url = URL(string: content) else { return  }
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { [unowned self] (image, _, _, _) in
            self.image = image
            self.dataLoadingStatus.onNext(.done)
        }
    }
}
