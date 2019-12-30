//
//  URLSchemes.swift
//  Cupid
//
//  Created by Trần Tý on 12/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

func callNumber(phoneNumber:String) {
    
    if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        
        let application:UIApplication = UIApplication.shared
        if application.canOpenURL(phoneCallURL) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}
