//
//  RNMessageAlertBridges.swift
//  Cupid
//
//  Created by Trần Tý on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(RNMessageAlertBridges)
class RNMessageAlertBridges: NSObject, RCTBridgeModule {
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
            selectionVC.dismiss(animated: false, completion: nil)
            if type == "OK" {
                selectionVC.handleOkButtonPress()
            } else {
                selectionVC.handleCancelButtonPress()
            }
            RNMessageAlertBridges.shared.alertVCMap.removeValue(forKey: id)
        }
    }
}
