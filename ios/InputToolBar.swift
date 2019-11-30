//
//  InputToolBar.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol InputToolBarDelegate: AnyObject {
    func inputToolBar(didChangeHeight toolBar: InputToolBar)
    
    func inputToolBar(onSendMessage type: MessageType, content: String)
}

enum InputToolBarState {
    case image
    case icon
    case text
    case noAction
}

class InputToolBar: UIView {
    
    weak var delegate: InputToolBarDelegate?
    
    var state: InputToolBarState = .noAction {
        didSet {
            updateHeightConstraint()
            galleryInput.layer.opacity = self.state == .image ? 1 : 0
        }
    }
    
    var contentView: UIStackView!
    
    var inputRow: UIStackView!
    
    var actionsView: ActionsView!
    
    var input: InputView!
    
    var sendButton: UIButton!
    
    var galleryInput: GalleryInput!
    
    var keyboarHeight: CGFloat = 0
    
    var isAnimating: Bool = false
    
    var height: CGFloat {
        switch state {
        case .image, .icon:
            return 308
        case .text:
            return keyboarHeight + inputRow.frame.height + 32
        case .noAction:
            return 65
        }
    }
    
    var isKeyboardShowing: Bool = false
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        initActions()
        initObservers()
    }
    
    func initUI() {
        actionsView = ActionsView()
        actionsView.delegate = self
        
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
        galleryInput.layer.opacity = 0
        
        contentView = UIStackView(arrangedSubviews: [inputRow, galleryInput])
        contentView.axis = .vertical
        contentView.alignment = .center
        contentView.spacing = 8
        addSubview(contentView)
    }
    
    func makeConstraints() {
        inputRow.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
            make.leading.equalTo(contentView).inset(16)
        }
        input.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(inputRow).multipliedBy(0.3)
        }
        
        galleryInput.snp.makeConstraints { (make) in
            make.width.equalTo(contentView)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func initActions() {
        sendButton.addTarget(self, action: #selector(onSendButtonPress), for: [.touchUpInside])
    }
    
    func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func onSendButtonPress() {
        delegate?.inputToolBar(onSendMessage: .text, content: input.value)
        input.clearValue()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        self.keyboarHeight = keyboardSize.cgRectValue.height - 85
        
//        self.updateHeightConstraint(withDuration: animationTimeInterval)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboarHeight = 0
    }
    
    func updateHeightConstraint(withDuration: TimeInterval = 0.25) {
        if isAnimating { return }
        self.isAnimating = true
        UIView.animate(withDuration: 0.25, animations: {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(self.height)
            }
        }, completion: { (_) in
            self.delegate?.inputToolBar(didChangeHeight: self)
            self.isAnimating = false
        })
    }
    
    deinit {
        sendButton.removeTarget(self, action: #selector(onSendButtonPress), for: [.touchUpInside])
        NotificationCenter.default.removeObserver(self)
    }
}

extension InputToolBar {
    func requestEndEditing() {
        endEditing(true)
        self.state = .noAction
    }
}

extension InputToolBar: InputViewDelegate {
    func inputViewDidBeginEditing(_ inputView: InputView) {
        self.state = .text
        self.actionsView.state = .collapse
        UIView.animate(withDuration: 0.2) {
            self.inputRow.distribution = .fill
            self.galleryInput.layer.opacity = 0
        }
    }
    
    func inputViewDidChange(_ inputView: InputView) {
        if actionsView.state == .expand {
            actionsView.state = .collapse
        }
        self.snp.updateConstraints { (make) in
            make.height.equalTo(self.height)
        }
    }
    
    func inputViewDidEndEditing(_ inputView: InputView) {
        self.actionsView.state = .expand
        UIView.animate(withDuration: 0.2) {
            self.inputRow.distribution = .equalSpacing
            self.snp.updateConstraints { (make) in
                make.height.equalTo(self.height)
            }
        }
    }
}


extension InputToolBar: ActionViewDelegate {
    func actionView(onOpenCamera actionView: ActionsView) {
        self.state = .image
        self.endEditing(true)
    }
    
    func actionView(onOpenGallery actionView: ActionsView) {
//        self.galleryInput.layer.opacity = 1
        self.state = .image
        self.endEditing(true)
    }
    
    func actionView(onStateChanged actionView: ActionsView) {
        let isExpanded: Bool = actionView.state == .expand
        self.inputRow.distribution = isExpanded ? .equalSpacing : .fill
    }
}
