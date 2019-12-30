//
//  DefaultData.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit

@objc class AppUserData: NSObject {
    
    static let kUserInfoChangedEventName = "kUserInfoChangedEventName"
    
    static let kUserTokenChangedEvent = NSNotification.Name(rawValue: "kUserTokenChangedEvent")
    
    static let shared = AppUserData()
    
    var userRepository = UserRepository()
    
    var friendInfo: User?
    
    var userInfo: User! {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppUserData.kUserInfoChangedEventName), object: nil, userInfo: nil)
        }
    }
    
    @objc dynamic var userToken: String {
        didSet {
            UserDefaults.standard.set(userToken, forKey: "token")
            NotificationCenter.default.post(name: AppUserData.kUserTokenChangedEvent, object: nil, userInfo: nil)
        }
    }
    
    override init() {
        userToken = UserDefaults.standard.string(forKey: "token") ?? ""
        super.init()
    }
    
    func logout() {
        DispatchQueue.main.async {
            self.userToken = ""
        }
    }
    
    func checkIsSignedIn() -> Promise<Bool> {
        return Promise<Bool> { seal in
            if userToken != "" {
                userRepository
                    .getUserProfile()
                    .done { (user) in
                        self.userInfo = user
                        LocationServices.shared.bootstrap(userModel: UserModel(user: user))
                        seal.fulfill(true)
                        NotificationServices.shared.registerForPushNotifications()
                }.catch { (_) in
                    seal.fulfill(false)
                }
            } else {
                seal.fulfill(false)
            }
        }
    }
}
