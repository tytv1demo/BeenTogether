//
//  GalleryImage.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class GalleryImage: UICollectionViewCell {
    
    static let CellIdentifer: String = "GalleryImage"
    
    var imageView: UIImageView!
    
    var isChoosingAction: Bool = false
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI() {
        imageView = UIImageView()
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func onTapImage() {
        if isChoosingAction {
            imageView.removeBlurEffect()
        } else {
            imageView.addBlurEffect()
        }
        isChoosingAction = !isChoosingAction
    }
    
    func configCellWith(image: UIImage) {
        imageView.image = image
    }
}
