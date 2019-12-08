//
//  SettingViewController.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class SettingViewController: RCTViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        view.configureLayout { (layout) in
            layout.isEnabled = true
            layout.paddingBottom = YGValue(value: Float(tabBarHeight), unit: .point)
        }
        view.yoga.applyLayout(preservingOrigin: true)
    }
}
