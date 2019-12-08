//
//  LocationServices.swift
//  Cupid
//
//  Created by Trần Tý on 12/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import MapKit
import RxSwift

class LocationServices: NSObject {
    
    static let shared: LocationServices = LocationServices()
    
    var currentLocation: BehaviorSubject<CLLocation?>
    
    var locationManager: CLLocationManager
    
    @objc dynamic var isAutomaticUpdateOfLocation: Bool {
        didSet {
            UserDefaults.standard.set(self.isAutomaticUpdateOfLocation, forKey: "isAutomaticUpdateOfLocation")
        }
    }

    override init() {
        currentLocation = BehaviorSubject<CLLocation?>(value: nil)
        locationManager = CLLocationManager()
        isAutomaticUpdateOfLocation = UserDefaults.standard.bool(forKey: "isAutomaticUpdateOfLocation")
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func enableLocationAutoUpdate() -> Bool {
        let isLocationServiceEnable = CLLocationManager.locationServicesEnabled()
        if isLocationServiceEnable {
            locationManager.delegate = self
            locationManager.desiredAccuracy = .zero
            locationManager.startUpdatingLocation()
            isAutomaticUpdateOfLocation = true
            return true
        }
        return false
    }
    
    func disableLocationAutoUpdate() -> Bool {
        if isAutomaticUpdateOfLocation {
            locationManager.stopUpdatingLocation()
            isAutomaticUpdateOfLocation = false
            return true
        }
        return false
    }
}

extension LocationServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation.onNext(locations.first)
    }
}
