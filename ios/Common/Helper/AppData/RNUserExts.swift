//
//  RNUserExts.swift
//  Cupid
//
//  Created by Trần Tý on 12/14/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol RCTModel {
    func toRCTValue() -> [String: Any]
}

extension User: RCTModel {
    func toRCTValue() -> [String: Any] {
        return [
            "id": id,
            "age": age,
            "name": name,
            "phoneNumber": phoneNumber,
            "isPaired": isPaired
        ]
    }
}


extension AppUserData: RCTModel {
    func toRCTValue() -> [String: Any] {
        if userInfo == nil {
            return [:]
        }
        return [
            "token": userToken
        ]
    }
}
