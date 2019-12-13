//
//  DefaultData.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

class AppUserData {
    
    static let shared = AppUserData()
    var userRepository = UserRepository()
    var userInfo: User?
    
    var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "token")
        }
    }
    
    init() {
        userToken = UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func checkIsSignedIn() -> Promise<Bool> {
        return Promise<Bool> { seal in
            if userToken != "" {
                userRepository
                    .getUserProfile()
                    .done { (user) in
                        self.userInfo = user
                        seal.fulfill(true)
                }.catch { (err) in
                    seal.fulfill(false)
                }
            } else {
                seal.fulfill(false)
            }
        }
    }
}
