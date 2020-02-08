//
//  RNMessageAlertBridges.swift
//  Cupid
//
//  Created by Trần Tý on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import MessageUI

@objc(RNMessageAlertBridges)
class RNMessageAlertBridges: NSObject, RCTBridgeModule, MFMailComposeViewControllerDelegate {
    static func moduleName() -> String! {
        return "RNMessageAlertBridges"
    }
    
    
    static let shared: RNMessageAlertBridges = RNMessageAlertBridges()
    
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    var alertVCMap: [String: MessageAlertViewController] = [:]
    
    @objc func selectAction(_ id: String, type: String) {
        guard let selectionVC = RNMessageAlertBridges.shared.alertVCMap[id] else {
            return
        }
        DispatchQueue.main.async {
            selectionVC.dismiss(animated: true, completion: nil)
            if type == "OK" {
                selectionVC.handleOkButtonPress()
            } else {
                selectionVC.handleCancelButtonPress()
            }
            RNMessageAlertBridges.shared.alertVCMap.removeValue(forKey: id)
        }
    }
    
    @objc func contactUs() {
        DispatchQueue.main.async {
            if MFMailComposeViewController.canSendMail() {
                let mailVc = MFMailComposeViewController()
                mailVc.mailComposeDelegate = self
                mailVc.setToRecipients(["ty.tv01@gmail.com"])
                guard let topViewController = UIApplication.topViewController() else { return }
                topViewController.present(mailVc, animated: true)
            } else {
                showMessage(title: "Oops!", message: "Can not open mail app!", theme: .warning)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func reloadApp() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appDelegate.window?.rootViewController = SplashViewController()
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
