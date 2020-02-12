//
//  GalleryAsset.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Photos
import PromiseKit
import RxSwift

class GalleryAsset {
    var asset: PHAsset
    
    var image: BehaviorSubject<UIImage?>
    
    init(asset: PHAsset) {
        self.asset = asset
        self.image = BehaviorSubject<UIImage?>(value: nil)
        fetchUIImageFromAsset(asset)
            .done { [unowned self] (image) in
                self.image.onNext(image)
        }.catch { (_) in
            
        }
    }
}

func fetchUIImageFromAsset(_ asset: PHAsset) -> Promise<UIImage?> {
    return Promise<UIImage?> { seal in
        DispatchQueue.global().async {
            let imageManager: PHImageManager = PHImageManager()
            
            let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .opportunistic
            
            let ratio: CGFloat = 0.3
            let width = CGFloat(asset.pixelWidth) * ratio
            let height = CGFloat(asset.pixelHeight) * ratio
            imageManager.requestImage(for: asset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: requestOptions) { (photo, _) in
                seal.fulfill(photo)
            }
        }
    }
}
