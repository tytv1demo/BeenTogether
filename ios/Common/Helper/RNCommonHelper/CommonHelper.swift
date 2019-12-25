//
//  FlashMessage.swift
//  Cupid
//
//  Created by Trần Tý on 12/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import SwiftMessages

@objc(RNCommonHelper)
class RNCommonHelper: NSObject, RCTBridgeModule {
    
    enum FlashMessageTheme: String {
        case info, success, warning
    }
    
    static func moduleName() -> String! {
        return "RNCommonHelper"
    }
    
    var methodQueue: DispatchQueue! = DispatchQueue.main
    
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    func getMessageTheme(from rawTheme: String) -> Theme {
        guard let theme = FlashMessageTheme(rawValue: rawTheme) else {
            return .error
        }
        
        switch theme {
        case .info:
            return .info
        case .warning:
            return .warning
        default:
            return .success
        }
    }

    @objc func showFlashMessage(_ title: String, message: String, rawTheme: String) {
        let theme = getMessageTheme(from: rawTheme)
        showMessage(title: title, message: message, theme: theme)
    }
}


func showMessage(title: String, message: String, theme: Theme) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureTheme(theme)
    view.configureDropShadow()
    
    view.button?.isHidden = true
    
    view.configureContent(title: title, body: message)
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    SwiftMessages.show(view: view)
}
