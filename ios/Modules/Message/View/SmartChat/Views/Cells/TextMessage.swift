//
//  TextMessage.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class TextMessageView: UIView, BaseMessageView {
    
    weak var delegate: MessageViewDelegate?
    
    var messages: [SCMessage]!
    
    var message: SCMessage!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var rowContentStack: UIStackView!
    
    var bubble: Bubble!
    
    var avatar: Avatar!
    
    var statusIndicator: MessageStatusIndicator!
    
    var tapGestureOnBubble: UITapGestureRecognizer?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        configActions()
    }
    
    func configUI() {
        statusIndicator = MessageStatusIndicator()
        
        bubble = Bubble()
        avatar = Avatar(size: CGSize(width: 25, height: 25), url: "")
        
        let arrangedSubviews: [UIView] = [UIView(), bubble, avatar, statusIndicator]
        
        rowContentStack = UIStackView(arrangedSubviews: arrangedSubviews)
        rowContentStack.spacing = 8
        rowContentStack.alignment = .bottom
        addSubview(rowContentStack)
        
        statusIndicator.snp.makeConstraints { (make) in
            make.size.equalTo(12)
        }
        
        rowContentStack.snp.makeConstraints { (make) in
            make.leading.equalTo(self).inset(8)
            make.trailing.equalTo(self).inset(8)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        bubble.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(self).multipliedBy(0.65)
            make.top.equalTo(rowContentStack)
            make.bottom.equalTo(rowContentStack)
        }
    }
    
    var bubbleRoundedCorners: UIRectCorner {
        var conners: UIRectCorner = [.topRight, .bottomRight]
        if isFirstMessageInGroup {
            conners = [.topLeft, .topRight, .bottomRight]
        }
        
        if isLastMessageInGroup {
            conners = [.bottomLeft, .topRight, .bottomRight]
        }
        
        if isUserMessage {
            conners = [.topLeft, .bottomLeft]
            if isFirstMessageInGroup {
                conners = [.topRight, .topLeft, .bottomLeft]
            }
            
            if isLastMessageInGroup {
                conners = [.bottomRight, .topLeft, .bottomLeft]
            }
        }
        
        if isLastMessageInGroup && isFirstMessageInGroup {
            conners =  [.allCorners]
        }
        
        return conners
    }
    
    func startConfigForUse() {
        avatar.isHidden = isUserMessage
        avatar.setImage(url: message.author.avatar ?? "")
        avatar.imageView.isHidden = !isLastMessageInGroup
        statusIndicator.isHidden = !isUserMessage
        
        statusIndicator.configWithMessage(message)
        
        bubble.setupWithMessage(message, isUserMessage: isUserMessage, roundCorners: bubbleRoundedCorners)
        rowContentStack.semanticContentAttribute = isUserMessage ? .forceLeftToRight : .forceRightToLeft
    }
    
    func configActions() {
        tapGestureOnBubble = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGestureOnBubble!)
    }
    
    @objc func didTap(_ sender: UIView?) {
        delegate?.messageView(didTap: self, onView: sender)
    }
    
    func prepareForReuse() {
        statusIndicator.prepareForReuse()
    }
}
