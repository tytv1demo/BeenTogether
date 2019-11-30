//
//  MessageCell.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class TextMessageCell: UITableViewCell {
    static let kCellIdentify: String = "TextMessageCell"
    
    var messageView: TextMessageView!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var messages: [SCMessage]!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TextMessageCell.kCellIdentify)
        selectionStyle = .none
        
        messageView = TextMessageView()
        contentView.addSubview(messageView)
        messageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        messageView.isUserInteractionEnabled = true
    }
    
    func configWith(messages: [SCMessage], at indexPath: IndexPath, andUser user: SCUser) {
        let message = messages[indexPath.item]
        self.messages = messages
        self.indexPath = indexPath
        self.user = user
        
        messageView.indexPath = indexPath
        messageView.message = message
        messageView.user = user
        messageView.messages = messages
        messageView.startConfigForUse()
    }
}
