//
//  URLSchemes.swift
//  Cupid
//
//  Created by Trần Tý on 12/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

func callNumber(phoneNumber: String) {
    if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application: UIApplication = UIApplication.shared
        
        if application.canOpenURL(phoneCallURL) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}

func openSetting() {
    DispatchQueue.main.async {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}

func openContactToUs(){
    DispatchQueue.main.async {
        let email = "tytv01@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
}
