//
//  EventModel.swift
//  Cupid
//
//  Created by Quan Tran on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct EventModel: Codable {
    var name: String?
    var description: String?
    var location: String?
    var startDate: String?
    var endDate: String?
    var attachments: [MediaModel]?
}

struct MediaModel: Codable {
    let url: String?
    let type: String?
}

enum MediaType: String {
    case IMAGE, VIDEO
}
