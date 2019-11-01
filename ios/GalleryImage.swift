//
//  GalleryImage.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class GalleryImage: UICollectionViewCell {
  
  static let CELL_IDENTIFER = "GalleryImage"
  
  var imageView: UIImageView!
  
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
    
    imageView.snp.makeConstraints { (m) in
      m.edges.equalTo(contentView)
    }
  }
  
  func configCellWith(image: UIImage) {
    imageView.image = image
  }
}
