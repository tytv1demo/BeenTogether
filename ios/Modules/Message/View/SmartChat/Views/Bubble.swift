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
        
        layer.masksToBounds = true
        layer.cornerRadius = 8
        
        messageLabel = UILabel()
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(8)
        }
    }
  
    func setupWithMessage(_ message: SCTextMessage, isUserMessage: Bool) {
        self.message = message
        backgroundColor = isUserMessage ? UIColor(rgb: 0xEE4E9B) : UIColor.groupTableViewBackground
        messageLabel.text = message.body
        messageLabel.textColor = isUserMessage ? .white : .black
    }
}
