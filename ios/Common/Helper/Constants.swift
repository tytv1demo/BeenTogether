//
//  Constants.swift
//  SmileMirror
//
//  Created by Lucas Lee on 8/7/18.
//  Copyright © 2018 OMM. All rights reserved.
//

import Foundation

// The uniform place where we state all the storyboard we have in our application
enum Storyboard: String {
    case loading = "Loading"
    case task = "Task"
    case dating = "Dating"
    case message = "Message"
    case profile = "Profile"
}

// Time Constants
enum TimeConstants: Double {
    case MILLISECOND = 0.001
    case SECOND = 1
    case MINUTE = 60
    case HOUR = 3600
    case DAY = 86400
    case WEEK = 604800
    case MONTH = 2629800
    case YEAR = 31557600
}

struct Colors {
    static let kPink: UIColor =  UIColor(rgb: 0xEE4E9B)
}
