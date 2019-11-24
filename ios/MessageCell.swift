//
//  MessageCell.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class MessageCell: UITableViewCell {
    static let kCellIdentify: String = "MessageCell"
    
    var messageView: MessageView!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var messages: [SCMessage]!

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MessageCell.kCellIdentify)
        selectionStyle = .none
        
    }
    
    func configWith(messages: [SCMessage], at indexPath: IndexPath, andUser user: SCUser) {
        let message = messages[indexPath.item]
        self.messages = messages
        self.indexPath = indexPath
        self.user = user
        
        messageView = MessageViewFactory.getMessageView(fromMessage: message)
        addSubview(messageView)
        messageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        messageView.isUserInteractionEnabled = true
        
        messageView.indexPath = indexPath
        messageView.message = message
        messageView.user = user
        messageView.messages = messages
        messageView.startConfigForUse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageView.removeFromSuperview()
    }
}
