//
//  GalleryInput.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import PromiseKit
import Photos

class GalleryInput: UIView {
    
    var collectionView: UICollectionView!
    var photos: Array<UIImage> = []
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryImage.self)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
//        fetchData()
    }
}

extension GalleryInput {
    
    func requestPhotoAuthorization() -> Promise<Bool> {
        return Promise<Bool> { seal in
            let currentStatus = PHPhotoLibrary.authorizationStatus()
            if currentStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (status) in
                    seal.fulfill(status == .authorized)
                }
            }
            seal.fulfill(currentStatus == .authorized)
        }
    }
    
    func fetchPhotos() {
        
        DispatchQueue.global(qos: .background).async {
            let imageManager: PHImageManager = PHImageManager.default()
            
            let requestOptions: PHImageRequestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .fastFormat
            
            let fetchOptions: PHFetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            for index in 0...fetchResult.count - 1 {
                let asset: PHAsset = fetchResult.object(at: index)
                imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (photo, error) in
                    if photo != nil {
                        self.photos.append(photo!)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchData() {
        requestPhotoAuthorization()
            .done { (isAuthorization) in
                if isAuthorization {
                    self.fetchPhotos()
                }
        }.catch { (_) in
            
        }
        
    }
}

extension GalleryInput: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell: GalleryImage = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImage.CellIdentifer, for: indexPath) as? GalleryImage else {
        return UICollectionViewCell()
    }

    cell.configCellWith(image: photos[indexPath.item])
    
    return cell
  }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.frame.width * 0.5 - 8
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: GalleryImage = collectionView.cellForItem(at: indexPath) as? GalleryImage else {
            return
        }
        
        cell.onTapImage()
    }
    
}
