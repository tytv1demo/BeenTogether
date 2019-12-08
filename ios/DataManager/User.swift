//
//  RemoteUser.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class UserLocation: Decodable {
    var coordinate: UserCoordinate?
    var startTime: Date?
}

class UserCoordinate: Decodable {
    var lat: Float?
    var lng: Float?
}

class User: Decodable {
    var id: Int = 0
    var coupleId: String = ""
    var name: String = ""
    var age: Int = 0
    var gender: String = ""
    var location: UserLocation?
    var phoneNumber: String = ""

    var isPaired: Bool {
        return coupleId != "\(id)_local"
    }
    
    enum RemoteUserKeys: String, CodingKey {
        case id, coupleId, name, age, gender, location, phoneNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RemoteUserKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        coupleId = try container.decode(String.self, forKey: .coupleId)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        gender = try container.decode(String.self, forKey: .gender)
        location = try container.decode(UserLocation.self, forKey: .location)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
    }
}

struct SignInResult: Decodable {
    var userInfo: User?
    var token: String = ""
    
    enum SignInResultKeys: String, CodingKey {
        case userInfo, token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SignInResultKeys.self)

        userInfo = try container.decode(User.self, forKey: .userInfo)
        token = try container.decode(String.self, forKey: .token)
    }
}

struct UserInfoResult: Decodable {
    var userInfo: User?
    
    enum UserInfoResultKeys: String, CodingKey {
        case userInfo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserInfoResultKeys.self)

        userInfo = try container.decode(User.self, forKey: .userInfo)
    }
}
