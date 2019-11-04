//
//  Bubble.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class Bubble: UIView {
  
  var messageLabel: UILabel!
  
  var message: SCTextMessage!
  
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init (frame: CGRect = CGRect.zero, message: SCTextMessage, isUserMessage: Bool) {
    self.init(frame: frame)
    self.message = message
    setupUI(isUserMessage: isUserMessage)
  }
  
  func setupUI(isUserMessage: Bool = true) {
    backgroundColor = isUserMessage ? UIColor(rgb: 0xEE4E9B) : UIColor.groupTableViewBackground
    layer.masksToBounds = true
    layer.cornerRadius = 8
    
    messageLabel = UILabel()
    addSubview(messageLabel)
    messageLabel.text = message.body
    messageLabel.textColor = isUserMessage ? .white : .black
    
    messageLabel.snp.makeConstraints { (make) in
      make.edges.equalTo(self).inset(8)
    }
    messageLabel.numberOfLines = 0
    messageLabel.sizeToFit()
  }
}
