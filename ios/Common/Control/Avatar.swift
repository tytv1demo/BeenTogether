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
        super.init(coder: coder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init (frame: CGRect = CGRect.zero, size: CGSize = CGSize(width: 40, height: 40), url: String) {
        self.init(frame: frame)
        
        snp.makeConstraints { (make) in
            make.size.equalTo(size)
        }
        
        setImage(url: url)
    }
    
    func setupUI() {
        imageView = UIImageView()
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = self.frame.height * 0.5
        imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(url: String) {
        let resource: URL = URL(string: url)!
        
        imageView.kf.setImage(with: resource)
    }
    
    func setLocalImage(named: String) {
        imageView.image = UIImage(named: named)
    }
}