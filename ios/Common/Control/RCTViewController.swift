//
//  RCTViewController.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class RCTViewController: UIViewController {
    
    var moduleName: String!
    
    var bridge: RCTBridge!
    
    func initRCTView() {
        bridge = RCTBridgeServices.shared.bridge
        view  = RCTRootView(bridge: bridge, moduleName: moduleName, initialProperties: [:])
    }
    
}
