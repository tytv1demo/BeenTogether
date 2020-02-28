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
    
    var viewModel: MessageViewModelProtocol!
    
    var gpsButton: UIButton!
    
    var phoneButton: UIButton!
    
    var moreButton: UIButton!
    
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
        subscribeViewModel()
    }
    
    func settupNavigation(completion: (() -> Void)? = nil) {
        navigationController?.navigationBar.backgroundColor = .white
        
//        gpsButton = UIButton(type: .custom)
//        gpsButton.setImage(UIImage(named: "gps"), for: [])
//        let gpsTabBarItem = UIBarButtonItem(customView: gpsButton)
        
        phoneButton = UIButton(type: .custom)
        phoneButton.setImage(UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: Colors.kPink, size: CGSize(width: 25, height: 25)), for: .normal)
        let phoneTabBarButton = UIBarButtonItem(customView: phoneButton)
        phoneTabBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        phoneTabBarButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
       
        moreButton = UIButton(type: .custom)
        moreButton.setImage(UIImage.fontAwesomeIcon(name: .flag, style: .solid, textColor: Colors.kPink, size: CGSize(width: 25, height: 25)), for: .normal)
        let moreTabBarButton = UIBarButtonItem(customView: moreButton)
        moreTabBarButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        moreTabBarButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        navigationItem.rightBarButtonItems = [moreTabBarButton, phoneTabBarButton]
        
        guard let friendConfig = try? viewModel.coupleModel.friendConfig.value() else {
            return
        }
        loverAvatar = Avatar(url: friendConfig.avatar)
        let avatarBarItem = UIBarButtonItem(customView: loverAvatar)
        
        loverNameLabel = UILabel()
        loverNameLabel.textColor = UIColor(rgb: 0xFA7268)
        let nameLabelTabBarItem = UIBarButtonItem(customView: loverNameLabel)
        loverNameLabel.text = friendConfig.name
        
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
//        gpsButton.addTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
        phoneButton.addTarget(self, action: #selector(onPhoneButtonPress), for: [.touchUpInside])
        moreButton.addTarget(self, action: #selector(handleMoreButtonDidTap), for: [.touchUpInside])
    }
    
    func subscribeViewModel() {
        viewModel.viewData.subscribe(onNext: { [weak self] (data) in
            self?.loverNameLabel?.text = data.loverName
            self?.loverAvatar?.setImage(url: data.loverAvatar)
        }).disposed(by: disposeBag)
    }
    
    @objc func onGpsButtonPress() {
        self.goToLocationScreen()
    }
    
    @objc func onPhoneButtonPress() {
        guard let phoneNumber = viewModel.coupleModel.friendInfo?.phoneNumber, phoneNumber != "0123456789" else {
            showAlertWithOneOption(title: "Opps!", message: "Sorry, we could not find your lover.", optionTitle: "OK")
            return
        }
        callNumber(phoneNumber: phoneNumber)
    }
    
    @objc func handleMoreButtonDidTap() {
        let reportVC = ReportViewController(nibName: "ReportViewController", bundle: nil)
        reportVC.isFromMessageVC = true
        reportVC.modalPresentationStyle = .formSheet
        reportVC.modalTransitionStyle = .coverVertical
        
        present(reportVC, animated: true, completion: nil)
    }
    
    deinit {
//        gpsButton?.removeTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
        phoneButton?.removeTarget(self, action: #selector(onPhoneButtonPress), for: [.touchUpInside])
        moreButton?.removeTarget(self, action: #selector(handleMoreButtonDidTap), for: [.touchUpInside])
    }
    
}

extension MessageViewController: SmartChatDelegate {
    
    func smartChat(onSendMessage type: MessageType, content: String) {
        viewModel.sendMessage(type: type, content: content)
    }
    
    func smartChat(onSendImage data: Data) {
        viewModel.sendImage(data: data)
    }
    
    func smartChat(onRequestOpenCamera smartChat: SmartChat) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentAlert(title: "Oops!", message: "Sorry, Camera is unavailabe now!", delegate: nil)
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func smartChat(onOpenMicro smartChat: SmartChat) {
        presentAlert(title: "Oops!", message: "Sorry, we are not support for this feature now!", delegate: nil)
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

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageData = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.jpegData(compressionQuality: 0.5) else {
            return
        }
        viewModel.sendImage(data: imageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
