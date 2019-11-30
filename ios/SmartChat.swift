//
//  SmartChartContainer.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit

protocol SmartChatDelegate: AnyObject {
    func smartChat(onSendMessage type: MessageType, content: String)
}

class SmartChat: UIView {
    
    weak var delegate: SmartChatDelegate?
    
    var messageTableView: MessageTableView!
    var inputToolBar: InputToolBar!
    
    var data: [SCMessage] = [] {
        didSet {
            messageTableView.messages = self.data
        }
    }
    
    var user: SCUser!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init (frame: CGRect = .zero, user: SCUser) {
        self.init(frame: frame)
        self.user = user
        setupUI()
    }
    
    func setupUI() {
        
        messageTableView = MessageTableView(user: user)
        addSubview(messageTableView)
        
        inputToolBar = InputToolBar()
        inputToolBar.delegate = self
        addSubview(inputToolBar)
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.leading.equalTo(self)
            make.bottom.equalTo(inputToolBar.snp.top)
        }
        
        inputToolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.trailing.equalTo(self)
            make.leading.equalTo(self)
            make.height.equalTo(self.inputToolBar.height)
        }
    }
}

extension SmartChat: InputToolBarDelegate {
    func inputToolBar(didChangeHeight toolBar: InputToolBar) {
        messageTableView.scrollToBottomIfNeeded()
    }
    
    func inputToolBar(onSendMessage type: MessageType, content: String) {
        delegate?.smartChat(onSendMessage: type, content: content)
    }
}

extension SmartChat: MessageTableViewDelegate {
    func messageTableView(didTap: MessageTableView, atIndexPath: IndexPath) {
        inputToolBar.requestEndEditing()
    }
    
}
