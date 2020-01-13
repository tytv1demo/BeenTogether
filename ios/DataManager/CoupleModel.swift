//
//  CoupleModel.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/30/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
import Firebase

class CoupleModel {
    var userInfo: User
    var friendId: String?
    var friendInfo: User?
    var startDate: BehaviorSubject<Double?>
    var userConfig: BehaviorSubject<Config?>
    var friendConfig: BehaviorSubject<Config?>
    var coupleRef: DatabaseReference
    var threadRef: DatabaseReference
    var startDateRef: DatabaseReference
    var userRepository: UserRepositoryProtocol
    
    init(userInfo: User) {
        self.userInfo = userInfo
        userRepository = UserRepository()
        userConfig = BehaviorSubject<Config?>(value: nil)
        friendConfig = BehaviorSubject<Config?>(value: nil)
        startDate = BehaviorSubject<Double?>(value: nil)
        
        coupleRef = Database.database().reference(withPath: "couples/\(userInfo.coupleId)/configs")
        threadRef = Database.database().reference()
        startDateRef = Database.database().reference(withPath: "couples/\(userInfo.coupleId)/startDate")
        
        friendId = getFriendId(otherId: String(userInfo.id), coupleId: userInfo.coupleId)
        
        _ = syncFriendInfo(friendId: self.friendId!).done { (success) in
            if success {
                self.observeCoupleConfigFromFirebase()
                self.observeStartDateFromFirebase()
            }
        }
    }
}

// Sync frieng info and couple data
extension CoupleModel {
    
    func syncFriendInfo(friendId: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            getFriendProfile(friendId: friendId).done { (user) in
                self.friendInfo = user
                seal.fulfill(true)
            }.catch { (_) in
                seal.fulfill(false)
            }
        }
    }
    
    func getFriendProfile(friendId: String) -> Promise<User> {
        return Promise<User> { seal in
            userRepository
                .getFriendProfile(friendId: friendId)
                .done { (user) in
                    self.friendInfo = user
                    seal.fulfill(user)
            }.catch { (err) in
                seal.reject(err)
            }
        }
    }
    
    func observeCoupleConfigFromFirebase() {
        coupleRef.observe(.value) { (snapshot) in
            guard let rawConfig = snapshot.value as? [String: [String: String]] else { return }
            guard let userConfig = rawConfig[self.userInfo.phoneNumber] else { return }
            guard let friendInfo = self.friendInfo else { return }
            guard let friendConfig = rawConfig[friendInfo.phoneNumber] else { return }
            
            self.userConfig.onNext(self.firbaseEntityToConfig(raw: userConfig))
            self.friendConfig.onNext(self.firbaseEntityToConfig(raw: friendConfig))
        }
    }
    
    func observeStartDateFromFirebase() {
        startDateRef.observe(.value) { (snapshot) in
            guard let rawStartDate = snapshot.value else { return }
            guard let timeInterval = rawStartDate as? Double else { return }
            
            self.startDate.onNext(timeInterval)
        }
    }
    
    func getFriendId(otherId: String, coupleId: String) -> String {
        let splitedArray = coupleId.split(separator: "_")
        
        for item in splitedArray {
            if String(item) != otherId {
                return String(item)
            }
        }
        
        return ""
    }
    
    func getFriendInfo(from user: User) -> User {
        let friendId = getFriendId(otherId: String(user.id), coupleId: user.coupleId)
        var friendInfo: User?
        
        _ = getFriendProfile(friendId: friendId).done { (user) in
            friendInfo = user
        }
        
        return friendInfo!
    }
    
    func firbaseEntityToConfig(raw: [String: Any]) -> Config {
        let name: String = String(raw["name"] as! String)
        let avatar: String = String(raw["avatar"] as! String)
        
        return Config(name: name, avatar: avatar)
    }
}

// Ref couple data
extension CoupleModel {
    
    func refPersonAvatar(avatarURL: String, person: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/\(person)/avatar")
            
            threadRef.setValue(avatarURL) { (err, _) in
                if err == nil {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
    
    func refPersonNickName(name: String, personId: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/\(personId)/name")
            
            threadRef.setValue(name) { (err, _) in
                if err == nil {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
    
    func refCoupleStartDate(startDate: Double) -> Promise<Bool> {
        return Promise<Bool> { seal in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/startDate")
            
            threadRef.setValue(startDate) { (err, _) in
                if err == nil {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
    
    func refBackground(backgroudURL: String) -> Promise<Bool> {
        return Promise<Bool> { seal in
            threadRef = Database.database().reference(withPath: "couples/\(self.userInfo.coupleId)/configs/background")
            
            threadRef.setValue(backgroudURL) { (err, _) in
                if err == nil {
                    seal.fulfill(true)
                } else {
                    seal.fulfill(false)
                }
            }
        }
    }
}
