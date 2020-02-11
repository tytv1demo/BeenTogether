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
        ref = Database.database().reference().child("event/\(AppUserData.shared.userInfo.coupleId)")
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
        
        let child = ref.childByAutoId()
        child.setValue([
            "id": child.key ?? "",
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
        ref.observeSingleEvent(of: .value) { snapshot in
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
    
    /// Delete an event
    /// - Parameter event: event going to be edited
    func delete(event: EventModel, completion: ((String) -> Void)?) {
        guard let id = event.id else {
            return
        }
        
        removeEvent(id: id, completion: completion)
        
        if let attachments = event.attachments {
            attachments.forEach { att in
                guard att.type == "IMAGE", let imageUrl = att.url else {
                    return
                }
                
                self.removeImages(url: imageUrl)
            }
        }
    }
    
    private func removeEvent(id: String, completion: ((String) -> Void)?) {
        ref.child(id).removeValue { error, _ in
            if let error = error {
                print(error)
            } else {
                completion?(id)
            }
        }
    }
    
    func removeImages(url: String) {
        let fbStorage = Storage.storage()
        let storageRef = fbStorage.reference()
        let childRef = storageRef.child("event_images/" + getImageUrl(wholeUrl: url))
        
        childRef.delete { error in
            if let error = error {
                print(error)
            }
        }
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
    func listenToAddEvent(completion: ((EventModel?) -> Void)?) {
        ref.observeSingleEvent(of: .value) { snap in
            if snap.exists() {
                self.ref.observe(.childAdded) { snapshot in
                    if let value = snapshot.value, let event = try? FirebaseDecoder().decode(EventModel.self, from: value) {
                        completion?(event)
                    }
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    private func getImageUrl(wholeUrl: String) -> String {
        let subSlash = wholeUrl.components(separatedBy: "%2F")
        let imageUrl = subSlash[1].components(separatedBy: "?alt=")
        return imageUrl[0]
    }
}
