//
//  UserModel.swift
//  Cupid
//
//  Created by Trần Tý on 12/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase
import SwiftMoment

class UserModel: NSObject {
    var info: User
    
    init(user: User) {
        info = user
    }
    
    func updateLocation(_ lat: Float, _ lng: Float) {
        let locationRef = Database.database().reference(withPath: "users/\(info.phoneNumber)/location")
        
        let coordinate = UserCoordinate(lat: lat, lng: lng)
        let location = UserLocation(coordinate: coordinate, startTime: moment())
        
        locationRef.setValue(location.rctValue)
    }
}
