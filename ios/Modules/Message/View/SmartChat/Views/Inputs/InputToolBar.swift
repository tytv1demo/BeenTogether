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
    
    func inputToolBar(onOpenMicro inputToolBar: InputToolBar)
    
    func inputToolBar(onRequestOpenCamera inputToolBar: InputToolBar)
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
            return keyboarHeight + inputRow.frame.height
        case .noAction:
            return 44
        }
    }
    
    var tabBarHeight: CGFloat {
        guard let topViewController = UIApplication.topViewController(), let tabController = topViewController.tabBarController else { return 0 }
        return tabController.tabBar.frame.height - 3
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
        updateStatusSendButton()
    }
    
    func updateStatusSendButton() {
        if input.value == "".trimmingCharacters(in: .whitespacesAndNewlines) {
            sendButton.isEnabled = false
            sendButton.setImage(UIImage.fontAwesomeIcon(name: .paperPlane, style: .solid, textColor: Colors.kLightGray, size: CGSize(width: 25, height: 25)), for: .disabled)
        } else {
            sendButton.isEnabled = true
            sendButton.setImage(UIImage.fontAwesomeIcon(name: .paperPlane, style: .solid, textColor: Colors.kPink, size: CGSize(width: 25, height: 25)), for: .normal)
        }
    }
    
    func initUI() {
        actionsView = ActionsView()
        actionsView.delegate = self
        
        input = InputView()
        input.delegate = self
        
        sendButton = UIButton()
        sendButton.tintColor = .red
//        sendButton.setImage(UIImage(named: "send"), for: [.normal])
        
        inputRow = UIStackView(arrangedSubviews: [actionsView, input, sendButton])
        inputRow.isLayoutMarginsRelativeArrangement = true
        inputRow.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
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
        inputRow.addGradientBackground(backgroundColors: [UIColor.groupTableViewBackground.withAlphaComponent(0.3), UIColor.groupTableViewBackground.withAlphaComponent(0.05)])
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
        updateStatusSendButton()
        self.updateStateBehavior()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        keyboarHeight = keyboardSize.cgRectValue.height - tabBarHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboarHeight = 0
        updateStateBehavior()
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
        updateStatusSendButton()
    }
    
    func inputViewDidChange(_ inputView: InputView) {
        if actionsView.state == .expand {
            actionsView.state = .collapse
        }
        self.updateStateBehavior()
        updateStatusSendButton()
    }
    
    func inputViewDidEndEditing(_ inputView: InputView) {
        if state != .emoji {
            self.actionsView.state = .expand
            UIView.animate(withDuration: 0.2) { [unowned self] in
                self.inputRow.distribution = .equalSpacing
            }
        }
        updateStatusSendButton()
    }
    
}

extension InputToolBar: GalleryInputDelegate {
    func galleryInput(onSendImage data: Data) {
        delegate?.inputToolBar(onSendImage: data)
    }
}


extension InputToolBar: ActionViewDelegate {
    func actionView(onOpenCamera actionView: ActionsView) {
        delegate?.inputToolBar(onRequestOpenCamera: self)
    }
    
    func actionView(onOpenMicro actionView: ActionsView) {
        delegate?.inputToolBar(onOpenMicro: self)
    }
    
    func actionView(onOpenGallery actionView: ActionsView) {
        self.state = .image
        self.endEditing(true)
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

extension UIApplication {
    class func topViewController(of controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(of: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(of: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(of: presented)
        }
        return controller
    }
}
