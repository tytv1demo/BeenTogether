//
//  AppService.swift
//  SmileMirror
//
//  Created by Lucas Lee on 8/7/18.
//  Copyright © 2018 OMM. All rights reserved.
//

import UIKit

class AppService: NSObject {
    
    static let sharedInstance = AppService()
    
    private override init() {
        super.init()
    }
    
    func bootstrap(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        log.verbose("Start App")
    }
    
}
