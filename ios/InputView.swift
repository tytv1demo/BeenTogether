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
}

class InputView: UIView {
    
    static let kDefaultHeight: CGFloat = 25
    
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
    }
    
    func initUI() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(rgb: 0xEE4E9B).cgColor
        layer.cornerRadius = 8
        
        inputField = UITextView()
        inputField.delegate = self
        
        emojiButton = UIButton()
        emojiButton.setImage(UIImage(named: "camera"), for: [])
        
        contentView = UIStackView(arrangedSubviews: [inputField, emojiButton])
        
        addSubview(contentView)
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        emojiButton.snp.makeConstraints { (make) in
            make.size.equalTo(24)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(InputView.kDefaultHeight)
        }
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
        snp.updateConstraints { (make) in
            make.height.equalTo(textView.contentSize.height)
        }
        delegate?.inputViewDidChange(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.inputViewDidEndEditing(self)
    }
}
