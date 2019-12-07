//
//  InputView.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol InputViewDelegate: AnyObject {
    func inputViewDidBeginEditing(_ inputView: InputView)
    
    func inputViewDidEndEditing(_ inputView: InputView)
    
    func inputViewDidChange(_ inputView: InputView)
    
    func inputView(requestShowHideEmojiInput inputView: InputView)
}

class InputView: UIView {
    
    static let kDefaultHeight: CGFloat = 28
    
    weak var delegate: InputViewDelegate?
    
    var inputField: UITextView!
    
    var emojiButton: UIButton!
    
    var contentView: UIStackView!
    
    var value: String {
        return inputField.text
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        setConstraints()
        addActions()
    }
    
    func initUI() {
        backgroundColor = .groupTableViewBackground
        layer.cornerRadius = InputView.kDefaultHeight * 0.5
        
        inputField = UITextView()
        inputField.backgroundColor = .clear
        inputField.delegate = self
        
        emojiButton = UIButton()
        let emojiImage = UIImage.awesomeIcon(name: .laugh, textColor: Colors.kPink)
        emojiButton.setImage(emojiImage, for: [])
        
        contentView = UIStackView(arrangedSubviews: [inputField, emojiButton])
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        contentView.alignment = .center
        
        addSubview(contentView)
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        emojiButton.snp.makeConstraints { (make) in
            make.size.equalTo(24)
        }
        
        inputField.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(contentView)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(InputView.kDefaultHeight)
        }
    }
    
    func addActions() {
        emojiButton.addTarget(self, action: #selector(onEmojiButtonPress), for: [.touchUpInside])
    }
    
    @objc func onEmojiButtonPress() {
        delegate?.inputView(requestShowHideEmojiInput: self)
    }
    
    func concatEmoji(_ emoji: String) {
        inputField.text += emoji
        autoResizeAdapForContent()
    }
    
    func autoResizeAdapForContent() {
        snp.updateConstraints {[unowned self] (make) in
            make.height.equalTo(self.inputField.contentSize.height)
        }
        delegate?.inputViewDidChange(self)
    }
    
    func clearValue() {
        inputField.text = ""
        snp.updateConstraints { (make) in
            make.height.equalTo(InputView.kDefaultHeight)
        }
    }
}

extension InputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.inputViewDidBeginEditing(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        autoResizeAdapForContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        snp.updateConstraints { (make) in
            make.height.equalTo(InputView.kDefaultHeight)
        }
        delegate?.inputViewDidEndEditing(self)
    }
}
