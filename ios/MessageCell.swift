//
//  MessageCell.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class MessageCell: UITableViewCell {
  static let kCellIdentify: String = "MessageCell"
  
  var messageView: MessageView!
  
  var user: SCUser!
  
  var indexPath: IndexPath!
  
  var messages: Array<SCMessage>!
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: MessageCell.kCellIdentify)
//    initUI()
  }
  
  func initUI() {
    messageView = MessageView()
    addSubview(messageView)
    messageView.snp.makeConstraints { (make) in
      make.edges.equalTo(self)
    }
  }
  
  func configWith(messages: Array<SCMessage>, at indexPath: IndexPath, andUser user: SCUser){
    initUI()
    let message = messages[indexPath.item]
    self.messages = messages
    self.indexPath = indexPath
    self.user = user
    
    messageView.indexPath = indexPath
    messageView.message = message
    messageView.user = user
    messageView.messages = messages
    messageView.configUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    messageView.removeFromSuperview()
  }
}
