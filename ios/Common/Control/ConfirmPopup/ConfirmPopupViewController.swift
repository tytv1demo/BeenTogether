//
//  ConfirmPopupViewController.swift
//  Cupid
//
//  Created by Trần Tý on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

protocol ConfirmPopupViewControllerDelegate: AnyObject {
    func confirmPopup(didAccept popup: ConfirmPopupViewController) -> Promise<Any>
    
    func confirmPopup(didCancel popup: ConfirmPopupViewController) -> Promise<Any>
}

class ConfirmPopupViewController: UIViewController {
    
    weak var delegate: ConfirmPopupViewControllerDelegate?
    
    var container: UIView!
    
    var headerBackground: UIView!
    
    var icon: UIImageView!
    
    var contentView: UIStackView!
    
    var titleLabel: UILabel!
    
    var messageLabel: UILabel!
    
    var actionStackView: UIStackView!
    
    var cancelButton: UIButton!
    
    var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        initUIs()
        makeConstrants()
        addActions()
    }
    
    func initUIs() {
        container = UIView()
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        view.addSubview(container)
        container.backgroundColor = .white
        
        headerBackground = UIView()
        headerBackground.backgroundColor = Colors.kPink
        container.addSubview(headerBackground)
        
        let heartbeat = UIImage.fontAwesomeIcon(name: .heartbeat, style: .solid, textColor: Colors.kPink, size: CGSize(width: 36, height: 36))
        icon = UIImageView(image: heartbeat)
        icon.contentMode = .top
        icon.backgroundColor = .white
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 32.5
        headerBackground.addSubview(icon)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: [])
        cancelButton.layer.borderColor = Colors.kPink.cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitleColor(Colors.kPink, for: [])
        
        acceptButton = UIButton()
        acceptButton.setTitle("Accept", for: [])
        acceptButton.backgroundColor = Colors.kPink
        acceptButton.layer.cornerRadius = 8
        
        actionStackView = UIStackView(arrangedSubviews: [cancelButton, acceptButton])
        actionStackView.distribution = .equalCentering
        
        contentView = UIStackView(arrangedSubviews: [titleLabel, messageLabel, actionStackView])
        container.addSubview(contentView)
        contentView.axis = .vertical
        contentView.alignment = .center
        contentView.spacing = 8

    }
    
    func makeConstrants() {
        container.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(250)
            make.center.equalToSuperview()
        }
        
        headerBackground.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        icon.snp.makeConstraints { (make) in
            make.size.equalTo(65)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(22.5)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerBackground.snp_bottom).offset(8)
            make.width.equalToSuperview().inset(8)
        }
        
        actionStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(8)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(65)
        }
        
        acceptButton.snp.makeConstraints { (make) in
            make.width.equalTo(65)
        }
    }
    
    func addActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: [.touchUpInside])
        acceptButton.addTarget(self, action: #selector(acceptButtonTouchUpInside), for: [.touchUpInside])
    }
    
    @objc func cancelButtonTouchUpInside() {
        acceptButton.showGradientSkeleton()
        delegate?.confirmPopup(didCancel: self).done({ [weak self] (_) in
            self?.acceptButton.hideSkeleton()
        }).catch({ [weak self] (_) in
            self?.acceptButton.hideSkeleton()
        })
    }
    
    @objc func acceptButtonTouchUpInside() {
        acceptButton.showGradientSkeleton()
        delegate?.confirmPopup(didAccept: self).done({ [weak self] (_) in
            self?.acceptButton.hideSkeleton()
        }).catch({ [weak self] (_) in
            self?.acceptButton.hideSkeleton()
        })
    }
    
    func setBehaviors(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    deinit {
        cancelButton?.removeTarget(self, action: #selector(cancelButtonTouchUpInside), for: [.touchUpInside])
        acceptButton?.removeTarget(self, action: #selector(acceptButtonTouchUpInside), for: [.touchUpInside])
    }
}

extension UIViewController {
    func presentConfirmPopup(title: String, message: String, delegate: ConfirmPopupViewControllerDelegate? = nil) {
        let popup = ConfirmPopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = delegate
        present(popup, animated: true) {
            popup.setBehaviors(title: title, message: message)
        }
    }
}
