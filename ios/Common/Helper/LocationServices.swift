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

    override init() {
        currentLocation = BehaviorSubject<CLLocation?>(value: nil)
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = .zero
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation.onNext(locations.first)
    }
}
