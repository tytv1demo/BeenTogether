//
//  InputToolBar.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class InputToolBar: UIView {
    
    var contentView: UIStackView!
    var inputRow: UIStackView!
    var actionsView: ActionsView!
    var input: InputView!
    var sendButton: UIButton!
    var galleryInput: GalleryInput!
    var keyboarHeight: CGFloat = 0
    
    var height: CGFloat {
        return keyboarHeight + inputRow.frame.height + 32
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initActions()
        initObservers()
    }
    
    func initUI() {
        
        addBorders(edges: [.top], color: .gray, thickness: 0.5)
        
        actionsView = ActionsView()
        
        input = InputView()
        input.delegate = self
        
        sendButton = UIButton()
        sendButton.tintColor = UIColor(rgb: 0xEE4E9B)
        sendButton.setImage(UIImage(named: "send"), for: [])
        
        inputRow = UIStackView(arrangedSubviews: [actionsView, input, sendButton])
        inputRow.alignment = .center
        inputRow.distribution = .equalSpacing
        inputRow.spacing = 8
        addSubview(inputRow)
        
        galleryInput = GalleryInput()
        
        inputRow.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        input.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(inputRow).multipliedBy(0.3)
        }
        
        contentView = UIStackView(arrangedSubviews: [inputRow, galleryInput])
        contentView.axis = .vertical
        contentView.spacing = 8
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(8)
        }
    }
    
    func initActions() {
        sendButton.addTarget(self, action: #selector(onSendButtonPress), for: [.touchUpInside])
    }
    
    func initObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    @objc func onSendButtonPress() {
        endEditing(true)
        input.clearValue()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let animationTimeInterval = TimeInterval(floatLiteral: animationDuration)
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        self.keyboarHeight = keyboardSize.cgRectValue.height
        
        UIView.animate(withDuration: animationTimeInterval) {
            self.snp.updateConstraints { make in
                make.height.equalTo(self.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboarHeight = 0
    }
    
    deinit {
        sendButton.removeTarget(self, action: #selector(onSendButtonPress), for: [.touchUpInside])
        NotificationCenter.default.removeObserver(self)
    }
}

extension InputToolBar: InputViewDelegate {
    func inputViewDidBeginEditing(_ inputView: InputView) {
        UIView.animate(withDuration: 0.2) {
            self.actionsView.isHidden = true
            self.inputRow.distribution = .fill
            self.galleryInput.layer.opacity = 0
        }
    }
    
    func inputViewDidChange(_ inputView: InputView) {
        self.snp.updateConstraints { (make) in
            make.height.equalTo(self.height)
        }
    }
    
    func inputViewDidEndEditing(_ inputView: InputView) {
        UIView.animate(withDuration: 0.2) {
            self.actionsView.isHidden = false
            self.inputRow.distribution = .equalSpacing
            self.snp.updateConstraints { (make) in
                make.height.equalTo(self.height)
            }
        }
    }
}
