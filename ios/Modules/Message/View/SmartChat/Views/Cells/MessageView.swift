//
//  MessageView.swift
//  Cupid
//
//  Created by Trần Tý on 11/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageViewDelegate: AnyObject {
    func messageView(didTap messageView: MessageView, onView: UIView?)
    
    func messageView(contentDidChange messageView: MessageView)
}


protocol MessageView: UIView {
    
    var delegate: MessageViewDelegate? { get set }
    
    var avatar: Avatar! { get set }
    
    var statusIndicator: MessageStatusIndicator! { get set }
    
    var messages: [SCMessage]! { get set }
    
    var message: SCMessage! { get set }
    
    var user: SCUser! { get set }
    
    var indexPath: IndexPath! { get set }
    
    var isFirstMessageInGroup: Bool { get }
    
    var isLastMessageInGroup: Bool { get }
    
    var isUserMessage: Bool { get }
    
    func startConfigForUse()
    
    func configUI()
    
    func configActions()
    
    func performUpdate()
    
    func prepareForReuse()
}

extension MessageView {
    
    var isFirstMessageInGroup: Bool {
        let prevMessageIndex = indexPath.item - 1
        if prevMessageIndex == -1 { return true }
        let prevMessages: SCMessage = messages[prevMessageIndex]
        return prevMessages.author.id != message.author.id
    }
    
    var isLastMessageInGroup: Bool {
        let nextMessageIndex = indexPath.item + 1
        if nextMessageIndex == messages.count { return true }
        let nextMessages: SCMessage = messages[nextMessageIndex]
        return nextMessages.author.id != message.author.id
    }
    
    var isUserMessage: Bool {
        return message.author.id == user.id
    }
    
    func performUpdate() {
        
    }
    
}


class MessageViewFactory {
    static func createView(for message: SCMessage) -> MessageView {
        switch message.type {
        case .text:
            return TextMessageView()
        default:
            return TextMessageView()
        }
    }
}
