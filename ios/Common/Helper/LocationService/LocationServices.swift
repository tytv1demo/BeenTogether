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

protocol LocationServicesDelegate: AnyObject {
    func locationServices(didChangeAuthorization locationServices: LocationServices, status: CLAuthorizationStatus)
}

class LocationServices: NSObject {
    
    static let shared: LocationServices = LocationServices()
    
    weak var delegate: LocationServicesDelegate?
    
    var currentLocation: BehaviorSubject<CLLocation?>
    
    var locationManager: CLLocationManager
    
    var authorizationStatus: CLAuthorizationStatus {
        didSet {
//            if !isAuthorization && isAutomaticUpdateOfLocation {
//                isAutomaticUpdateOfLocation = false
//            }
        }
    }
    
    var isAuthorization: Bool {
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    var userModel: UserModel?
    
    @objc dynamic var isAutomaticUpdateOfLocation: Bool = false {
        didSet {
            UserDefaults.standard.set(self.isAutomaticUpdateOfLocation, forKey: "isAutomaticUpdateOfLocation")
        }
    }

    override init() {
        currentLocation = BehaviorSubject<CLLocation?>(value: nil)
        locationManager = CLLocationManager()
        isAutomaticUpdateOfLocation = UserDefaults.standard.bool(forKey: "isAutomaticUpdateOfLocation")
        authorizationStatus = CLLocationManager.authorizationStatus()
        super.init()
        locationManager.delegate = self
    }
    
    func bootstrap(userModel: UserModel) {
        self.userModel = userModel
    }
    
    func requestAuthorizationIfNeeded() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        let isRequestable = authorizationStatus == .notDetermined
        if isRequestable {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        return false
    }
    
    func enableLocationAutoUpdate() -> Bool {
        if !isAuthorization {
            openSettingForLocation()
            return false
        }
        let isLocationServiceEnable = CLLocationManager.locationServicesEnabled()
        if isLocationServiceEnable {
            isAutomaticUpdateOfLocation = true
            return true
        }
        return false
    }
    
    func disableLocationAutoUpdate() -> Bool {
        if isAutomaticUpdateOfLocation {
            isAutomaticUpdateOfLocation = false
            return true
        }
        return false
    }
    
    func startUpdateLocation() {
        locationManager.desiredAccuracy = .zero
        locationManager.startUpdatingLocation()
    }
}

extension LocationServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let currentCoor = try? currentLocation.value()?.coordinate
        if currentCoor?.latitude == location.coordinate.latitude && currentCoor?.longitude == location.coordinate.longitude {
            return
        }
        self.currentLocation.onNext(location)
        if isAutomaticUpdateOfLocation {
            let lat = Float(location.coordinate.latitude)
            let lng = Float(location.coordinate.longitude)
            userModel?.updateLocation(lat, lng)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        delegate?.locationServices(didChangeAuthorization: self, status: status)
    }
}
