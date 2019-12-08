//
//  RNLocationServices.swift
//  Cupid
//
//  Created by Trần Tý on 12/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(RNLocationServices)
class RNLocationServices: RCTEventEmitter {
    
    enum RCTLocationEvent: String {
        case locationChanged, automaticUpdateStateChanged
    }
    
    var autoUpdateLocationStateObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        subscribeAutoUpdateStateChange()
    }
    
    
    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return [
            RCTLocationEvent.locationChanged.rawValue,
            RCTLocationEvent.automaticUpdateStateChanged.rawValue
        ]
    }
    
    override func constantsToExport() -> [AnyHashable : Any]! {
        return [
            "isAutomaticUpdateOfLocation": LocationServices.shared.isAutomaticUpdateOfLocation,
            "automaticUpdateStateChangedEvent": RCTLocationEvent.automaticUpdateStateChanged.rawValue
        ]
    }
    
    func subscribeAutoUpdateStateChange() {
        autoUpdateLocationStateObservation = LocationServices.shared.observe(\.isAutomaticUpdateOfLocation) { [unowned self] (_, _) in
            self.sendEvent(type: .automaticUpdateStateChanged, body: ["value": LocationServices.shared.isAutomaticUpdateOfLocation])
        }
    }
    
    
    func sendEvent(type: RCTLocationEvent, body: Any!) {
        self.sendEvent(withName: type.rawValue, body: body)
    }
    
    @objc(enableLocationUpdate:rejecter:)
    func enableLocationUpdate(
        resolve: RCTPromiseResolveBlock,
        reject: RCTPromiseRejectBlock) {
        let result = LocationServices.shared.enableLocationAutoUpdate()
        resolve(result)
    }
    
    @objc(disableLocationUpdate:rejecter:)
    func disableLocationUpdate(
        resolve: RCTPromiseResolveBlock,
        reject: RCTPromiseRejectBlock) {
        let result = LocationServices.shared.disableLocationAutoUpdate()
        resolve(result)
    }
    
    deinit {
        autoUpdateLocationStateObservation?.invalidate()
    }
}
