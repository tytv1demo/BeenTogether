//
//  PhoneNumeber.swift
//  Cupid
//
//  Created by Dung Nguyen on 1/18/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import PhoneNumberKit

func parsePhoneNumber(_ phoneNumber: String, _ regionCode: String) throws -> String {
    let phoneNumberKit = PhoneNumberKit()
    let parsedPhoneNumber = try phoneNumberKit.parse(phoneNumber, withRegion: regionCode, ignoreType: true)
    
    return "+\(parsedPhoneNumber.countryCode)\(parsedPhoneNumber.nationalNumber)"
}
