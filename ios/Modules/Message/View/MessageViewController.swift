//
//  MessageViewController.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import RxSwift

protocol MessageViewControllerProtocol: AnyObject {
    
    var viewModel: MessageViewModelProtocol! { get set }
    
}

class MessageViewController: UIViewController, MessageViewControllerProtocol {
    
    var viewModel: MessageViewModelProtocol! = MessageViewModel()
    
    var gpsButton: UIButton!
    
    var phoneButton: UIButton!
    
    var loverNameLabel: UILabel!
    
    var loverAvatar: Avatar!
    
    var smartChat: SmartChat!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupNavigation()
        setupChatUI()
        setupActions()
        
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func settupNavigation() {
        navigationController?.navigationBar.backgroundColor = .white
        
        gpsButton = UIButton(type: .custom)
        gpsButton.setImage(UIImage(named: "gps"), for: [])
        let gpsTabBarItem = UIBarButtonItem(customView: gpsButton)
        
        phoneButton = UIButton(type: .custom)
        phoneButton.setImage(UIImage(named: "phone"), for: [])
        let phoneTabBarButton = UIBarButtonItem(customView: phoneButton)
        
        navigationItem.rightBarButtonItems = [gpsTabBarItem, phoneTabBarButton]
        
        loverAvatar = Avatar(url: "https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg")
        let avatarBarItem = UIBarButtonItem(customView: loverAvatar)
        
        loverNameLabel = UILabel()
        loverNameLabel.textColor = UIColor(rgb: 0xFA7268)
        let nameLabelTabBarItem = UIBarButtonItem(customView: loverNameLabel)
        loverNameLabel.text = "Lover"
        
        navigationItem.leftBarButtonItems = [avatarBarItem, nameLabelTabBarItem]
    }
    
    func setupChatUI() {
        smartChat = SmartChat(user: viewModel.user)
        smartChat.delegate = self
        
        if let messages = try? viewModel.messages.value() {
            smartChat.reloadWithMessages(messages)
        }
        
        view.addSubview(smartChat)
        smartChat.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            if let tab = tabBarController?.tabBar {
                make.bottom.equalTo(view).inset(tab.frame.height)
            }
        }
    }
    
    func setupActions() {
        gpsButton.addTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
    }
    
    @objc func onGpsButtonPress() {
        self.goToLocationScreen()
    }
    
    @objc func onPhoneButtonPress() {
        
    }
    
    deinit {
        gpsButton.removeTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
    }
    
}

extension MessageViewController: SmartChatDelegate {
    
    func smartChat(onSendMessage type: MessageType, content: String) {
        viewModel.sendMessage(type: type, content: content)
    }
    
    func smartChat(onSendImage data: Data) {
        viewModel.sendImage(data: data)
    }
}

extension MessageViewController: MessageViewModelDelegate {
    func messageViewModel(didLoadMessages viewModel: MessageViewModelProtocol, messages: [SCMessage]) {
        smartChat.reloadWithMessages(messages)
    }
    
    func messageViewModel(didAddMessage viewModel: MessageViewModelProtocol, message: SCMessage) {
        smartChat.addMessage(message)
    }
}
