//
//  EventModel.swift
//  Cupid
//
//  Created by Quan Tran on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct EventModel: Codable, Equatable {
    var name: String?
    var description: String?
    var location: String?
    var startDate: String?
    var endDate: String?
    var attachments: [MediaModel]?
    var creator: String?
    
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        return lhs.name == rhs.name
            && lhs.description == rhs.description
            && lhs.location == rhs.location
            && lhs.startDate == rhs.startDate
            && lhs.endDate == rhs.endDate
            && lhs.attachments == rhs.attachments
            && lhs.creator == rhs.creator
    }
}

struct MediaModel: Codable, Equatable {
    let url: String?
    let type: String?
    
    static func == (lhs: MediaModel, rhs: MediaModel) -> Bool {
        return lhs.url == rhs.url && lhs.type == rhs.type
    }
}

enum MediaType: String {
    case IMAGE, VIDEO
}
