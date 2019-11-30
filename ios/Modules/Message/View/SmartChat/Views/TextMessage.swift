//
//  TextMessage.swift
//  Cupid
//
//  Created by Trần Tý on 10/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class TextMessageView: UIView, MessageView {
    
    weak var delegate: MessageViewDelegate?
    
    var messages: [SCMessage]!
    
    var message: SCMessage!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var rowContentStack: UIStackView!
    var bubble: Bubble!
    var avatar: Avatar!
    
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
        bubble = Bubble()
        avatar = Avatar(size: CGSize(width: 25, height: 25), url: "https://media.ex-cdn.com/EXP/media.giadinhvietnam.com/files/dothanhhien85/2018/10/01/42975856_2321943271154026_70249855187943424_n-1720.jpg")
        
        let arrangedSubviews: [UIView] = [UIView(), bubble, avatar]
        
        rowContentStack = UIStackView(arrangedSubviews: arrangedSubviews)
        rowContentStack.alignment = .bottom
        addSubview(rowContentStack)
        
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
    
    func startConfigForUse() {
        avatar.isHidden = isUserMessage
        avatar.imageView.isHidden = !isLastMessageInGroup
        
        guard let message = message as? SCTextMessage else { return }
        bubble.setupWithMessage(message, isUserMessage: isUserMessage)
        rowContentStack.semanticContentAttribute = isUserMessage ? .forceLeftToRight : .forceRightToLeft
    }
    
    func configActions() {
        tapGestureOnBubble = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGestureOnBubble!)
    }
    
    @objc func didTap(_ sender: UIView?) {
        delegate?.messageView(didTap: self, onView: sender)
    }
}
