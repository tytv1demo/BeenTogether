//
//  Couples.swift
//  Cupid
//
//  Created by Trần Tý on 12/21/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import SwiftMoment

enum CoupleMatchRequestStatus: String {
    case pending = "PENDING"
    case later = "LATER"
    case reject = "REJECT"
    case accept = "ACCEPT"
}

struct CoupleMatchRequest {
    var createdAt: Moment
    var from: User
    var status: CoupleMatchRequestStatus
    
    enum CoupleMatchRequestKeys: String, CodingKey {
        case createdAt, from, status
    }
}

extension CoupleMatchRequest: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CoupleMatchRequestKeys.self)
        from = try container.decode(User.self, forKey: .from)
        let rawStatus = try container.decode(String.self, forKey: .status)
        status = CoupleMatchRequestStatus(rawValue: rawStatus) ?? .pending
        
        let rawCreatedAt = try container.decode(Int.self, forKey: .createdAt)
        createdAt = moment(rawCreatedAt)
    }
}

struct GetNewestCoupleMatchRequestResult: Decodable {
    var request: CoupleMatchRequest?
    
    enum Keys: String, CodingKey {
        case request
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        request = try container.decode(CoupleMatchRequest.self, forKey: .request)
    }
}
