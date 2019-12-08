//
//  EmojiCollection.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol EmojiCollectionViewDelegate: AnyObject {
    func emojiCollectionView(didSelectEmoji emojiCollectionView: EmojiCollectionView,  emoji: String)
}

class EmojiCollectionView: UIView {
    
    weak var delegate: EmojiCollectionViewDelegate?
    
    var collectionView: UICollectionView!
    
    var emojies: [UnicodeScalar] = []
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojies = getAllEmojies()
        
        initUI()
        setConstraints()
    }
    
    func initUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.kCellIdentifer)
        
        addSubview(collectionView)
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.kCellIdentifer, for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        
        cell.configCellForEmoji(emojies[indexPath.item])
        return cell
    }
}

extension EmojiCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emojiCode = emojies[indexPath.item]
        let emoji = String(emojiCode)
        delegate?.emojiCollectionView(didSelectEmoji: self, emoji: emoji)
    }
}


func getAllEmojies() -> [UnicodeScalar] {
    let emojiRanges = 0x1F601...0x1F64F
    
    return emojiRanges.map({ UnicodeScalar($0)! })
}
