//
//  RemoteUser.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct RemoteUser {
    var id: Int?
    var coupleId: String?
    var name: String?
    var age: Int?
    var gender: String?
    var location: UserLocation?
    var phoneNumber: String?
}

struct UserInfoResult: Decodable {
    var userInfo: RemoteUser?
    
    enum UserInfoResultKeys: String, CodingKey {
        case userInfo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserInfoResultKeys.self)

        userInfo = try container.decode(RemoteUser.self, forKey: .userInfo)
    }
}

extension RemoteUser: Decodable {
    enum RemoteUserKeys: String, CodingKey {
        case id, coupleId, name, age, gender, location, phoneNumber
    }
    
    init(from decoder: Decoder) throws {
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
