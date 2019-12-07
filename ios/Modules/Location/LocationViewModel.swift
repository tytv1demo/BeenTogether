//
//  LocationViewModel.swift
//  Cupid
//
//  Created by Trần Tý on 12/5/19.


import RxSwift
import MapKit
import Firebase
import SwiftMoment


class CustomLocation {
    var coordinate: CLLocationCoordinate2D
    
    var lastUpdate: Moment
    
    init(coordinate: CLLocationCoordinate2D, lastUpdate: Int) {
        self.coordinate = coordinate
        
        self.lastUpdate = moment(lastUpdate)
    }
}

protocol LocationViewModelType: AnyObject {
    var currentLocation: BehaviorSubject<CLLocation?> { get }
    
    var loverLocation: BehaviorSubject<CustomLocation?> { get }
}

class LocationViewModel: LocationViewModelType {
    
    var loverLocationRef: DatabaseReference
    
    var currentLocation: BehaviorSubject<CLLocation?>
    
    var loverLocation: BehaviorSubject<CustomLocation?>
    
    init(loverPath: String) {
        currentLocation = LocationServices.shared.currentLocation
        
        loverLocation = BehaviorSubject<CustomLocation?>(value: nil)
        
        loverLocationRef = Database.database().reference(withPath: "users/\(loverPath)/location")
        
        startSubscribeLoverLocation()
    }
    
    func startSubscribeLoverLocation() {
        loverLocationRef
            .observe(.value) { [unowned self] (snapshot) in
                guard let data = snapshot.value as?  [String: Any] else {
                    return
                }
                guard let coordinateData = data["coordinate"] as? [String: CLLocationDegrees], let lastUpdate = data["from"] as? Int else {
                    return
                }
                let nextCoordinate = CLLocationCoordinate2D(latitude: coordinateData["lat"]!, longitude: coordinateData["lng"]!)
                let nextLocation = CustomLocation(coordinate: nextCoordinate, lastUpdate: lastUpdate)
                self.loverLocation.onNext(nextLocation)
        }
    }
}
