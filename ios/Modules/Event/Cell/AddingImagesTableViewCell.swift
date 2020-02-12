//
//  AddingImagesTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/19/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class AddingImagesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imagesCollection: UICollectionView!
    
    var parentVC: UIViewController?
    var dataSource: [Data] = [UIImage(named: "ic_add")!.jpegData(compressionQuality: 0.8)!]
    var didSelectImageCallback: ((Data) -> Void)?
    var didDeleteCallback: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        imagesCollection.register(UINib(nibName: "AddingImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddingImageCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Collection data source and delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddingImageCollectionViewCell", for: indexPath) as? AddingImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageData = dataSource[indexPath.row]
        cell.imgView.image = UIImage(data: imageData)
        cell.deleteButton.isHidden = indexPath.row == 0
        cell.didDeleteCallback = { image in
            self.didDeleteCallback?(indexPath.row - 1)
            self.dataSource.remove(at: indexPath.row)
            let index = IndexPath(row: indexPath.row, section: 0)
            self.imagesCollection.deleteItems(at: [index])
            self.imagesCollection.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 176, height: 176)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            openImagePicker()
        }
    }
    
    func openImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker(withSource: .camera)
            } else {
                let notAvailAlert = UIAlertController(title: "Opps!", message: "Camera is not available!", preferredStyle: .alert)
                notAvailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.parentVC?.present(notAvailAlert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Open Library", style: .default, handler: { _ in
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            guard let topViewController = UIApplication.topViewController() else { return }
            topViewController.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        parentVC?.present(alert, animated: true, completion: nil)
    }
    
    private func imagePicker(withSource sourceType: UIImagePickerController.SourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        parentVC?.present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage, let uploadData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        didSelectImageCallback?(uploadData)
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddingImagesTableViewCell: OpalImagePickerControllerDelegate {
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        assets.forEach {
            _ = fetchUIImageFromAsset($0).done { [weak self] (image) in
                guard let data = image?.jpegData(compressionQuality: 0.7) else {
                    return
                }
                self?.didSelectImageCallback?(data)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
