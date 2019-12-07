//
//  User.swift
//  SmileMirror
//
//  Created by Lucas Lee on 8/6/18.
//  Copyright © 2018 OMM. All rights reserved.
//

import UIKit

class User {
    var id: Int?
    var coupleId: String?
    var name: String?
    var age: Int?
    var gender: Bool?
    var location: UserLocation?
    var phoneNumber: String?
}

class UserLocation: Decodable {
    var coordinate: UserCoordinate?
    var startTime: Date?
}

class UserCoordinate: Decodable {
    var lat: Float?
    var lng: Float?
}
