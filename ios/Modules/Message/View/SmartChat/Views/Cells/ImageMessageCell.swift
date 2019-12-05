//
//  ImageMessageCell.swift
//  Cupid
//
//  Created by Trần Tý on 12/1/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class ImageMessageCell: UITableViewCell, MessageCell {

    static let kCellIdentify: String = "ImageMessageCell"
    
    var messageView: MessageView!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var messages: [SCMessage]!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ImageMessageCell.kCellIdentify)
        initUI()
    }
    
    func initUI() {
        selectionStyle = .none
        
        messageView = ImageMessageView()
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
