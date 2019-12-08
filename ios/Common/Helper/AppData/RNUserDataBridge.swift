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
        case userInfoChanged
    }
    
    var hasListener: Bool = false
    
    var userInfoObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        subscribeToUserInfoChanging()
    }
    
    
    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return [
            RCTEvent.userInfoChanged.rawValue
        ]
    }
    
    override func constantsToExport() -> [AnyHashable: Any]! {
        return [
            "userInfoChangedEvent": RCTEvent.userInfoChanged.rawValue,
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
    
    func subscribeToUserInfoChanging() {
        let eventName = NSNotification.Name(rawValue: AppUserData.kUserInfoChangedEventName)
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoDidChange), name: eventName, object: nil)
    }
    
    @objc func userInfoDidChange() {
        sendEvent(type: .userInfoChanged, body: AppUserData.shared.toRCTValue())
    }
    
    override func addListener(_ eventName: String!) {
        super.addListener(eventName)
        if eventName == RCTEvent.userInfoChanged.rawValue {
            sendEvent(type: .userInfoChanged, body: AppUserData.shared.toRCTValue())
        }
    }
    
    func sendEvent(type: RCTEvent, body: Any!) {
        if hasListener {
            self.sendEvent(withName: type.rawValue, body: body)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
