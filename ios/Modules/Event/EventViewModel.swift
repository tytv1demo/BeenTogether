//
//  EventViewModel.swift
//  Cupid
//
//  Created by Quan Tran on 12/23/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct EventViewModel {
    
    /// Create an event
    /// - Parameter event: event's model
    /// - Parameter completion: handler after create
    func create(event: EventModel, completion: (() -> Void)?) {
        completion?()
    }
    
    /// Get events for user
    /// - Parameter completion: handler after get events
    func getEvents(completion: (() -> Void)?) -> [EventModel] {
        return []
    }
    
    /// Edit an event
    /// - Parameter event: event going to be edited
    /// - Parameter completion: handler after edit
    func edit(event: EventModel, completion: (() -> Void)?) {
        
    }
    
    /// Upload an image
    /// - Parameters:
    ///   - image: image data
    ///   - completion: handler after finish
    func upload(image: Data, completion: ((String) -> Void)?) {
        UploadAPI.shared.uploadEventImages(imageData: image, completion: completion)
    }
}
