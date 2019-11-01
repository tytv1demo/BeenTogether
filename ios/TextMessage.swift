//
//  TextMessage.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class MessageView: UIView {
  
  var rowContentStack: UIStackView!
  
  var bubble: Bubble!
  
  var avatar: Avatar!
  
  var messages: Array<SCMessage>!
  
  var message: SCMessage!
  
  var user: SCUser!
  
  var indexPath: IndexPath!
  
  var isFirstMessageInGroup: Bool {
    let prevMessageIndex = indexPath.item - 1
    if prevMessageIndex == -1 { return true }
    let prevMessages: SCMessage = messages[prevMessageIndex]
    return prevMessages.author.id != user.id
  }
  
  var isLastMessageInGroup: Bool {
    let nextMessageIndex = indexPath.item + 1
    if nextMessageIndex == messages.count { return true }
    let nextMessages: SCMessage = messages[nextMessageIndex]
    return nextMessages.author.id != user.id
  }
  
  var isUserMessage: Bool {
    return message.author.id == user.id
  }
  
  func configUI(){
    print(indexPath.item)
    print(isLastMessageInGroup)
    avatar = Avatar(size: CGSize(width: 25, height: 25), url: "https://media.ex-cdn.com/EXP/media.giadinhvietnam.com/files/dothanhhien85/2018/10/01/42975856_2321943271154026_70249855187943424_n-1720.jpg")
    avatar.isHidden = isUserMessage || !isLastMessageInGroup
  
    bubble = Bubble(message: message as! SCTextMessage, isUserMessage: isUserMessage)
    
    let a: Array<UIView> = isUserMessage ? [UIView(), bubble, avatar] : [avatar, bubble, UIView()]
    
    rowContentStack = UIStackView(arrangedSubviews: a)
//    contentStack.distribution = .equalSpacing
    rowContentStack.alignment = .bottom
    addSubview(rowContentStack)
    rowContentStack.snp.makeConstraints { (m) in
      m.leading.equalTo(self).inset(8)
      m.trailing.equalTo(self).inset(8)
      m.top.equalTo(self)
      m.bottom.equalTo(self)
    }
    
    bubble.snp.makeConstraints { (m) in
      m.width.lessThanOrEqualTo(self).multipliedBy(0.6)
      m.top.equalTo(rowContentStack)
      m.bottom.equalTo(rowContentStack)
    }
  }
}

class TextMessageView: MessageView {
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
}
