//
//  RCTBridgeServices.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class RCTBridgeServices: NSObject, RCTBridgeDelegate {
    
    static let shared: RCTBridgeServices = RCTBridgeServices()
    
    var bridge: RCTBridge!
    
    func bootstrap(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
         bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    }
    
    func sourceURL(for bridge: RCTBridge!) -> URL! {
        #if DEBUG
            return RCTBundleURLProvider.sharedSettings()?.jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
        #else
            return RCTBundleURLProvider.sharedSettings()?.jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
        #endif
    }
    
}
