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
    
    var message: SCMessage!
    
    var roundCorners: UIRectCorner = []
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        messageLabel = UILabel()
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(8)
        }
    }
    
    func setupWithMessage(_ message: SCMessage, isUserMessage: Bool, roundCorners: UIRectCorner = []) {
        self.message = message
        self.roundCorners = roundCorners
        backgroundColor = isUserMessage ? UIColor(rgb: 0xEE4E9B) : UIColor.groupTableViewBackground
        messageLabel.text = message.content
        messageLabel.textColor = isUserMessage ? .white : .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRoundedCorner(corners: roundCorners, radius: 16)
    }
}
