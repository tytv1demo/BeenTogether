//
//  EmojiCell.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class EmojiCell: UICollectionViewCell {
    
    static let kCellIdentifer: String = "EmojiCell"
    
    var emojiLabel: UILabel!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    
    func initUI() {
        emojiLabel = UILabel()
        emojiLabel.font = emojiLabel.font.withSize(20)
        contentView.addSubview(emojiLabel)
    }
    
    func makeConstraints() {
        emojiLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    func onTapEmoji() {
       
    }
    
    func configCellForEmoji(_ emoji: UnicodeScalar) {
        let emojiString = String(emoji)
        emojiLabel.text = emojiString
    }
}
