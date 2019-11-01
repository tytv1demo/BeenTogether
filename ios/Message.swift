//
//  Message.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol SCMessageType {
  
}

class SCMessage {
  var id: Int
  var author: SCUser
  var createdAt: String
  var isDeleted: Bool
  
  init(id: Int, createdAt: String, author: SCUser, isDeleted: Bool = false) {
    self.id = id
    self.createdAt = createdAt
    self.isDeleted = isDeleted
    self.author = author
  }
}

class SCTextMessage: SCMessage {
  
  var body: String
  
  init(id: Int, createdAt: String, author: SCUser, isDeleted: Bool = false, body: String) {
    self.body = body
    super.init(id: id, createdAt: createdAt, author: author, isDeleted: isDeleted)
  }
}

class SCImageMessage: SCMessage {
  
  var image: URL
  
  init(id: Int, createdAt: String, author: SCUser, isDeleted: Bool = false, image: String) {
    self.image = URL(string: image)!
    super.init(id: id, createdAt: createdAt, author: author, isDeleted: isDeleted)
  }
}
