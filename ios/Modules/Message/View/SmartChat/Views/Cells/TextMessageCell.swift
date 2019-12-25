//
//  MessageCell.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageCell: UITableViewCell {
    
    var messageView: BaseMessageView! { get set }
    
    var user: SCUser! { get set }
    
    var indexPath: IndexPath! { get set }
    
    var messages: [SCMessage]! { get set }
    
    func initUI()
    
    func configCell(_ messages: [SCMessage], at indexPath: IndexPath, andUser user: SCUser)
}

extension MessageCell {
    
    func configCell(_ messages: [SCMessage], at indexPath: IndexPath, andUser user: SCUser) {
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

class TextMessageCell: UITableViewCell, MessageCell {

    static let kCellIdentify: String = "TextMessageCell"
    
    var messageView: BaseMessageView!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var messages: [SCMessage]!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TextMessageCell.kCellIdentify)
        initUI()
    }
    
    func initUI() {
        selectionStyle = .none
        
        messageView = TextMessageView()
        contentView.addSubview(messageView)
        messageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(2)
        }
        messageView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageView.prepareForReuse()
    }
}
