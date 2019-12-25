//
//  UserDataBridge.swift
//  Cupid
//
//  Created by Trần Tý on 12/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(RNAppUserDataBridge)
class RNAppUserDataBridge: RCTEventEmitter {
    
    enum RCTEvent: String {
        case userTokenChanged
    }
    
    var hasListener: Bool = false
    
    var userTokenObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        subscribeUserTokenChanging()
    }
    
    
    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return [
            RCTEvent.userTokenChanged.rawValue
        ]
    }
    
    override func constantsToExport() -> [AnyHashable: Any]! {
        return [
            "userTokenChanged": RCTEvent.userTokenChanged.rawValue,
            "data": AppUserData.shared.toRCTValue()
        ]
    }
    
    override func startObserving() {
        super.startObserving()
        hasListener = true
    }
    
    override func stopObserving() {
        super.stopObserving()
        hasListener = false
    }
    
    func subscribeUserTokenChanging() {
        userTokenObservation = AppUserData.shared.observe(\.userToken) { [weak self] (_, _) in
            self?.sendEvent(type: .userTokenChanged, body: AppUserData.shared.userToken)
        }
    }
    
    @objc func userTokenDidChange() {
        sendEvent(type: .userTokenChanged, body: AppUserData.shared.toRCTValue())
    }
    
    override func addListener(_ eventName: String!) {
        super.addListener(eventName)
        if eventName == RCTEvent.userTokenChanged.rawValue {
            sendEvent(type: .userTokenChanged, body: AppUserData.shared.userToken)
        }
    }
    
    func sendEvent(type: RCTEvent, body: Any!) {
        if hasListener {
            self.sendEvent(withName: type.rawValue, body: body)
        }
    }
    
    @objc func logout() {
        AppUserData.shared.logout()
    }
    
    deinit {
        userTokenObservation?.invalidate()
    }
}
