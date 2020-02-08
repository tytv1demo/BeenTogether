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

protocol GalleryInputDelegate: AnyObject {
    func galleryInput(onSendImage data: Data)
}

class GalleryInput: UIView {
    
    weak var delegate: GalleryInputDelegate?
    
    var collectionView: UICollectionView!
    
    weak var selectedCell: GalleryImageCell?
    
    var galleryButton: UIButton!
    
    var assets: [GalleryAsset] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        requestPhotoAuthorization()
            .done { [unowned self] (granted) in
                if granted {
                    self.fetchPhotos()
                } else {
                    self.setEmptyViewForCollectionView()
                }
        }.catch { [unowned self] (_) in
            self.setEmptyViewForCollectionView()
        }
    }
    
    func initUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.kCellIdentifer)
        
        addSubview(collectionView)
        
        galleryButton = UIButton()
        galleryButton.layer.masksToBounds = true
        galleryButton.layer.cornerRadius = 28
        galleryButton.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        galleryButton.setImage(UIImage.awesomeIcon(name: .fileImage, textColor: .white), for: [])
        
        galleryButton.addTarget(self, action: #selector(openGallery), for: [.touchUpInside])
        
        addSubview(galleryButton)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        galleryButton.snp.makeConstraints { (make) in
            make.size.equalTo(56)
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    deinit {
        galleryButton.removeTarget(self, action: #selector(openGallery), for: [.touchUpInside])
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
            } else {
                seal.fulfill(currentStatus == .authorized)
            }
            
        }
    }
    
    func fetchPhotos() {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions: PHFetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var assets: [GalleryAsset] = []
            for index in 0...fetchResult.count - 1 {
                let asset: PHAsset = fetchResult.object(at: index)
                let galleryAsset = GalleryAsset(asset: asset)
                assets.append(galleryAsset)
            }
            self.assets = assets
        }
    }
    
    func setEmptyViewForCollectionView() {
        let message = "Cho phép Cupid truy cập ảnh để có thể chia sẻ?"
        let buttonTitle = "Cho phép"
        self.collectionView.setEmptyMessage(message, buttonTitle: buttonTitle, onButtonPress: openSetting)
    }
    
    func openSetting() {
        let alertController = UIAlertController(title: "Oops!", message: "We don't have permission to read your photo! Go to Setting and then allow to access your photo?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
 
        guard let topController = UIApplication.topViewController() else { return }
        topController.present(alertController, animated: true, completion: nil)
    }
    
    @objc func openGallery() {
        guard let topViewcontroller = UIApplication.topViewController() else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        topViewcontroller.present(imagePickerController, animated: true, completion: nil)
    }

}

extension GalleryInput: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GalleryImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.kCellIdentifer, for: indexPath) as? GalleryImageCell else {
            return UICollectionViewCell()
        }
        let asset = assets[indexPath.item]
        cell.delegate = self
        cell.configCellWithAsset(asset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.frame.width * 0.5 - 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: GalleryImageCell = collectionView.cellForItem(at: indexPath) as? GalleryImageCell else {
            return
        }
        selectedCell?.hideActions()
        if selectedCell == cell {
            selectedCell = nil
            return
        }
        cell.showActions()
        selectedCell = cell
    }
    
}

extension GalleryInput: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageData = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.jpegData(compressionQuality: 0.5) else {
            return
        }
        delegate?.galleryInput(onSendImage: imageData)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension GalleryInput: GalleryImageCellDelegate {
    func sendImageMessage(fromCell cell: GalleryImageCell) {
        guard let data = try? cell.asset.image.value()?.jpegData(compressionQuality: 1) else {
            return
        }
        delegate?.galleryInput(onSendImage: data)
    }
    
    func sendAlarmImageMessage(fromCell cell: GalleryImageCell) {
        
    }
    
    func galleryImageCell(didSelect cell: GalleryImageCell, action: GalleryImageCellAction) {
        switch action {
        case .send:
            sendImageMessage(fromCell: cell)
        default:
            sendAlarmImageMessage(fromCell: cell)
        }
        
    }
}
