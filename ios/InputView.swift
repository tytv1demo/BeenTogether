//
//  InputView.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol InputViewDelegate {
  func inputViewDidBeginEditing(_ inputView: InputView)
  
  func inputViewDidEndEditing(_ inputView: InputView)
  
  func inputViewDidChange(_ inputView: InputView)
}

class InputView: UIView {
  
  static let DEFAULT_HEIGHT: CGFloat = 25
  
  var delegate: InputViewDelegate?
  
  var inputField: UITextView!
  
  var value: String {
    return inputField.text
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initUI()
  }
  
  func initUI() {
    inputField = UITextView()
//    inputField.placeholder = "Type a message..."
    
    inputField.layer.borderWidth = 0.5
    inputField.layer.borderColor = UIColor(rgb: 0xEE4E9B).cgColor
    inputField.layer.cornerRadius = 8
    
    addSubview(inputField)
    inputField.snp.makeConstraints { (m) in
      m.edges.equalTo(self)
    }
    
    snp.makeConstraints { (m) in
      m.height.equalTo(InputView.DEFAULT_HEIGHT)
    }
    
    inputField.delegate = self
  }
  
  func clearValue() {
    inputField.text = ""
    snp.updateConstraints { (m) in
      m.height.equalTo(InputView.DEFAULT_HEIGHT)
    }
  }
}

extension InputView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    delegate?.inputViewDidBeginEditing(self)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    snp.updateConstraints { (m) in
      m.height.equalTo(textView.contentSize.height)
    }
    delegate?.inputViewDidChange(self)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
     delegate?.inputViewDidEndEditing(self)
  }

}
