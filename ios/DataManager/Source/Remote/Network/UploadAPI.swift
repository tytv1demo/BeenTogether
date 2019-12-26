//
//  UploadAPI.swift
//  Cupid
//
//  Created by Quan Tran on 12/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase

class UploadAPI {
    static let shared = UploadAPI()
    private init() {}
    
    let fbStorage = Storage.storage()
    
    private func upload(imageData: Data, to folder: String, name: String, completion: ((String) -> Void)?) {
        let storageRef = fbStorage.reference()
        let childRef = storageRef.child("\(folder)/\(name).jpg")
        _ = childRef.putData(imageData, metadata: nil) { metadata, error in
            // TO-DO: Handle metadata and error
            guard metadata != nil else {
                print(error)
                return
            }
            
            childRef.downloadURL { (url, _) in
                guard let downloadURL = url else {
                    return
                }
                
                completion?(downloadURL.absoluteString)
            }
        }
    }
    
    func uploadAvatar(imageData: Data, for user: String, completion: ((String) -> Void)?) {
        upload(imageData: imageData, to: "avatar_images/\(user)", name: "\(AppUserData.shared.userInfo.id)_\(Date().timeIntervalSince1970)", completion: completion)
    }
    
    func uploadEventImages(imageData: Data, completion: ((String) -> Void)?) {
        upload(imageData: imageData, to: "event_images", name: "\(AppUserData.shared.userInfo.id)_\(AppUserData.shared.userInfo.coupleId)_\(Date().timeIntervalSince1970)", completion: completion)
    }
}
