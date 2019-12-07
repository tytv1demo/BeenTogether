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
    
    func inputToolBar(onSendImage data: Data)
}

enum InputToolBarState {
    case image
    case emoji
    case text
    case noAction
}

class InputToolBar: UIView {
    
    weak var delegate: InputToolBarDelegate?
    
    var state: InputToolBarState = .noAction {
        didSet {
            self.updateStateBehavior()
        }
    }
    
    var contentView: UIStackView!
    
    var spaceOfContentView: UIView!
    
    var inputRow: UIStackView!
    
    var actionsView: ActionsView!
    
    var input: InputView!
    
    var sendButton: UIButton!
    
    var galleryInput: GalleryInput!
    
    var emojiCollection: EmojiCollectionView!
    
    var keyboarHeight: CGFloat = 0
    
    var height: CGFloat {
        switch state {
        case .image, .emoji:
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
        
        setGradientBackground(colors: [.groupTableViewBackground, .white])
        
        actionsView = ActionsView()
        actionsView.delegate = self
        
        input = InputView()
        input.delegate = self
        
        sendButton = UIButton()
        sendButton.tintColor = .red
        sendButton.setImage(UIImage(named: "send"), for: [])
        
        inputRow = UIStackView(arrangedSubviews: [actionsView, input, sendButton])
        inputRow.isLayoutMarginsRelativeArrangement = true
        inputRow.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        inputRow.alignment = .center
        inputRow.distribution = .equalSpacing
        inputRow.spacing = 8
        addSubview(inputRow)
        
        galleryInput = GalleryInput()
        galleryInput.delegate = self
        galleryInput.isHidden = true
        
        emojiCollection = EmojiCollectionView()
        emojiCollection.delegate = self
        emojiCollection.isHidden = true

        spaceOfContentView = UIView()
        spaceOfContentView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        contentView = UIStackView(arrangedSubviews: [inputRow, galleryInput, emojiCollection, spaceOfContentView])
        contentView.axis = .vertical
        contentView.alignment = .fill
        contentView.spacing = 8
        addSubview(contentView)
    }
    
    func makeConstraints() {
        input.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(inputRow).multipliedBy(0.35)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        self.updateStateBehavior()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        self.keyboarHeight = keyboardSize.cgRectValue.height - 85
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboarHeight = 0
    }
    
    func updateStateBehavior(withDuration: TimeInterval = 0.25) {
        if state != .noAction {
           updateAccessories()
        }
        
        UIView.animate(withDuration: withDuration, animations: { [unowned self] in
            self.snp.updateConstraints { (make) in
                make.height.equalTo(self.height)
            }
            self.layoutIfNeeded()
        }, completion: { [unowned self] (_) in
            if self.state == .noAction {
                self.updateAccessories()
            }
            self.delegate?.inputToolBar(didChangeHeight: self)
        })
    }
    
    func updateAccessories() {
        galleryInput.isHidden = state != .image
        emojiCollection.isHidden = state != .emoji
        self.spaceOfContentView.isHidden = state == .emoji || state == .image
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
    func inputView(requestShowHideEmojiInput inputView: InputView) {
        if state != .emoji {
            state = .emoji
            endEditing(true)
        }
    }
    
    func inputViewDidBeginEditing(_ inputView: InputView) {
        self.state = .text
        self.actionsView.state = .collapse
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.inputRow.distribution = .fill
        }
    }
    
    func inputViewDidChange(_ inputView: InputView) {
        if actionsView.state == .expand {
            actionsView.state = .collapse
        }
        self.updateStateBehavior()
    }
    
    func inputViewDidEndEditing(_ inputView: InputView) {
        if state != .emoji {
            self.actionsView.state = .expand
            UIView.animate(withDuration: 0.2) { [unowned self] in
                self.inputRow.distribution = .equalSpacing
            }
        }
    }
    
}

extension InputToolBar: GalleryInputDelegate {
    func galleryInput(onSendImage data: Data) {
        delegate?.inputToolBar(onSendImage: data)
    }
}


extension InputToolBar: ActionViewDelegate {
    func actionView(onOpenCamera actionView: ActionsView) {
        self.state = .image
        self.endEditing(true)
    }
    
    func actionView(onOpenGallery actionView: ActionsView) {
        DispatchQueue.main.async { [unowned self] in
            self.state = .image
            self.endEditing(true)
        }
    }
    
    func actionView(onStateChanged actionView: ActionsView) {
        let isExpanded: Bool = actionView.state == .expand
        self.inputRow.distribution = isExpanded ? .equalSpacing : .fill
    }
}

extension InputToolBar: EmojiCollectionViewDelegate {
    func emojiCollectionView(didSelectEmoji emojiCollectionView: EmojiCollectionView, emoji: String) {
        input.concatEmoji(emoji)
    }
}
