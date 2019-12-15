//
//  MessageAlertViewController.swift
//  Cupid
//
//  Created by Trần Tý on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol MessageAlertViewControllerDelegate: AnyObject {
    func messageAlert(didCancel alert: MessageAlertViewController)
    
    func messageAlert(didOk alert: MessageAlertViewController)
}

class MessageAlertViewController: RCTViewController {
    weak var delegate: MessageAlertViewControllerDelegate?
    
    
    func handleOkButtonPress() {
        delegate?.messageAlert(didOk: self)
    }
    
    func handleCancelButtonPress() {
        delegate?.messageAlert(didCancel: self)
    }
}


extension UIViewController {
    func presentAlert(title: String, message: String, delegate: MessageAlertViewControllerDelegate?) {
        let alertViewController = MessageAlertViewController()
        alertViewController.moduleName = "MessageAlertView"
        let properties: [String: Any] = [
            "id": "test",
            "title": title,
            "message": message
        ]
        alertViewController.delegate = delegate
        alertViewController.initRCTView(initialProperties: properties)
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: false, completion: nil)
        alertViewController.view.backgroundColor = .clear
        RNMessageAlertBridges.shared.alertVCMap["test"] = alertViewController
    }
}
