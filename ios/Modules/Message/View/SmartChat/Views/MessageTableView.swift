//
//  MessageTableView.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageTableViewDelegate: AnyObject {
    func messageTableView(didTap messageView: MessageView, onView: UIView?)
}

class MessageTableView: UIView {
    
    weak var delegate: MessageTableViewDelegate?
    
    var tableView: UITableView!
    
    var messages: [SCMessage] = []
    
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
        tableView = UITableView()
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        tableView.register(TextMessageCell.self, forCellReuseIdentifier: TextMessageCell.kCellIdentify)
        tableView.register(ImageMessageCell.self, forCellReuseIdentifier: ImageMessageCell.kCellIdentify)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func addMessage(_ message: SCMessage) {
        messages.append(message)
        tableView.beginUpdates()
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        let prevIndexPath = IndexPath(item: messages.count - 2, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadRows(at: [prevIndexPath], with: .automatic)
        tableView.endUpdates()
        forceScrollToBottom()
    }
    
}

extension MessageTableView {
    func scrollToBottomIfNeeded() {
        guard let lastIndexPath = tableView.indexPathsForVisibleRows?.last else {
            return
        }
    
        if lastIndexPath.item == messages.count - 1 {
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    func forceScrollToBottom() {
        if messages.count == 0 {
            return
        }
        tableView.scrollToRow(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension MessageTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let identifer = message.type == .text ? TextMessageCell.kCellIdentify: ImageMessageCell.kCellIdentify
        let cell: MessageCell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! MessageCell
        cell.configCell(messages, at: indexPath, andUser: user)
        cell.messageView.delegate = self
        
        return cell
    }
}

extension MessageTableView: MessageViewDelegate {
    func messageView(didTap messageView: MessageView, onView: UIView?) {
        delegate?.messageTableView(didTap: messageView, onView: onView)
    }
    
    func messageView(contentDidChange messageView: MessageView) {
        UIView.animate(withDuration: 0.25) {
            self.tableView.beginUpdates()
            messageView.performUpdate()
            self.tableView.endUpdates()
        }
    }
}
