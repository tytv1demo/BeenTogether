//
//  MessageTableView.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageTableViewDelegate: AnyObject {
    func messageTableView(didTap: MessageTableView, atIndexPath: IndexPath)
}

class MessageTableView: UIView {
    
    weak var delegate: MessageTableViewDelegate?
    
    var tableView: UITableView!
    
    var messages: [SCMessage] = [] {
        didSet {
            tableView.reloadData()
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
        tableView = UITableView()
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        tableView.register(TextMessageCell.self, forCellReuseIdentifier: TextMessageCell.kCellIdentify)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
}

extension MessageTableView {
    func scrollToBottomIfNeeded() {
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
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.kCellIdentify) as? MessageCell else { return UITableViewCell() }
        let cell: TextMessageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configWith(messages: messages, at: indexPath, andUser: user)
        cell.messageView.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.messageTableView(didTap: self, atIndexPath: indexPath)
    }
}

extension MessageTableView: MessageViewDelegate {
    func messageView(didTap messageView: MessageView, onView: UIView?) {
      
    }
}
