//
//  EventViewModel.swift
//  Cupid
//
//  Created by Quan Tran on 12/23/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import CodableFirebase

struct EventViewModel {
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    /// Create an event
    /// - Parameter event: event's model
    /// - Parameter completion: handler after create
    func create(event: EventModel, completion: (() -> Void)?) {
        var attachmments: [[String: String]] = []
        
        if let attachs = event.attachments {
            attachs.forEach { att in
                let singleAtt = [
                    "type": att.type ?? "",
                    "url": att.url ?? ""
                ]
                attachmments.append(singleAtt)
            }
        }
        
        ref.child("event/\(AppUserData.shared.userInfo.coupleId)").childByAutoId().setValue([
            "attachments": attachmments,
            "description": event.description ?? "",
            "startDate": event.startDate ?? "",
            "endDate": event.endDate ?? "",
            "location": event.location ?? "",
            "name": event.name ?? ""
        ]) { error, _ in
            if let error = error {
                print(error)
            } else {
                completion?()
            }
        }
    }
    
    /// Get events for user
    /// - Parameter completion: handler after get events
    func getEvents(completion: (([EventModel]) -> Void)?) {
        ref.child("event/\(AppUserData.shared.userInfo.coupleId)").observe(.value) { snapshot in
            var listEvent: [EventModel] = []
            for child in snapshot.children.allObjects {
                guard let snap = child as? DataSnapshot, let value = snap.value else {
                    return
                }
                
                if let event = try? FirebaseDecoder().decode(EventModel.self, from: value) {
                    listEvent.append(event)
                }
            }
            
            completion?(listEvent)
        }
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
    
    /// Handler when event is added
    /// - Parameter completion: UI handler
    func listenToAddEvent(completion: ((EventModel) -> Void)?) {
        ref.child("event/\(AppUserData.shared.userInfo.coupleId)").observe(.childAdded) { snapshot in
            if let value = snapshot.value, let event = try? FirebaseDecoder().decode(EventModel.self, from: value) {
                completion?(event)
            }
        }
    }
    
    /// Handler when event is removed
    /// - Parameter completion: UI handler
    func listenToRemoveEvent(completion: ((EventModel) -> Void)?) {
        ref.child("event/\(AppUserData.shared.userInfo.coupleId)").observe(.childRemoved) { snapshot in
            if let value = snapshot.value, let event = try? FirebaseDecoder().decode(EventModel.self, from: value) {
                completion?(event)
            }
        }
    }
}
