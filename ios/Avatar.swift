//
//  Avatar.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Kingfisher

class Avatar: UIView {
  
  var imageView: UIImageView!
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init (frame: CGRect = CGRect.zero, size: CGSize = CGSize(width: 40, height: 40), url: String) {
    self.init(frame: frame)
    snp.makeConstraints { (m) in
      m.size.equalTo(size)
    }
    
    imageView = UIImageView()
    addSubview(imageView)
    
    let resource: URL = URL(string: url)!
    
    imageView.kf.setImage(with: resource)
    
    imageView.snp.makeConstraints { (make) in
      make.size.equalTo(self)
    }
    
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = size.height * 0.5
    imageView.contentMode = .scaleAspectFill
  }
  
  
}
