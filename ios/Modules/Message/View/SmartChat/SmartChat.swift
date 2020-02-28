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
    
    func smartChat(onSendImage data: Data)
    
    func smartChat(onOpenMicro smartChat: SmartChat)
    
    func smartChat(onRequestOpenCamera smartChat: SmartChat)
}

class SmartChat: UIView {
    
    weak var delegate: SmartChatDelegate?
    
    var messageTableView: MessageTableView!
    
    var inputToolBar: InputToolBar!
    
    var user: SCUser!
    
    var target: SCUser!
    
    var tapGestureOnMessageTable: UITapGestureRecognizer!
    
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
        setupActions()
    }
    
    func setupUI() {
        messageTableView = MessageTableView(user: user)
        messageTableView.delegate = self
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
    
    func setupActions() {
        tapGestureOnMessageTable = UITapGestureRecognizer(target: self, action: #selector(onTableViewTapped))
        messageTableView.addGestureRecognizer(tapGestureOnMessageTable)
    }
    
    func reloadWithMessages(_ messages: [SCMessage]) {
        messageTableView.messages = messages
        messageTableView.tableView.reloadData()
        messageTableView.tableView.scrollToBottom()
        if messages.count == 0 {
            setEmptyViewForTableView()
        }
    }
    
    func addMessage(_ message: SCMessage) {
        messageTableView.tableView.removeEmptyView()
        messageTableView.addMessage(message)
    }
    
    @objc func onTableViewTapped() {
        inputToolBar.requestEndEditing()
    }
    
    func setEmptyViewForTableView() {
        let message = "Hi \(user.name ?? ""), how do you feel today? Let send it for your lover!"
        let buttonTitle = ""
        let emptyView = self.messageTableView.tableView.setEmptyMessage(message, buttonTitle: buttonTitle, onButtonPress: openSetting)
        emptyView.button.isHidden = true
    }
    
    deinit {
        messageTableView.removeGestureRecognizer(tapGestureOnMessageTable)
        tapGestureOnMessageTable.removeTarget(self, action: #selector(onTableViewTapped))
    }
}

extension SmartChat: InputToolBarDelegate {
    func inputToolBar(didChangeHeight toolBar: InputToolBar) {
        messageTableView.scrollToBottomIfNeeded()
    }
    
    func inputToolBar(onSendMessage type: MessageType, content: String) {
        delegate?.smartChat(onSendMessage: type, content: content)
    }
    
    func inputToolBar(onSendImage data: Data) {
        delegate?.smartChat(onSendImage: data)
    }
    
    func inputToolBar(onRequestOpenCamera inputToolBar: InputToolBar) {
        delegate?.smartChat(onRequestOpenCamera: self)
    }
    
    func inputToolBar(onOpenMicro inputToolBar: InputToolBar) {
        delegate?.smartChat(onOpenMicro: self)
    }
}

extension SmartChat: MessageTableViewDelegate {
    func messageTableView(didTap messageView: BaseMessageView, onView: UIView?) {
        inputToolBar.requestEndEditing()
    }
}
