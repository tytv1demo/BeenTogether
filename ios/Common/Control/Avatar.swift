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
    
    static let kDefaultAvatar = URL(string: "https://www.clearone.com/sites/default/files/default_images/default-user-icon-4.jpg")
    
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
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Colors.kPink.cgColor
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(url: String) {
        let resource = URL(string: url)
        
        imageView.kf.setImage(with: resource ?? Avatar.kDefaultAvatar)
    }
    
    func setLocalImage(named: String) {
        imageView.image = UIImage(named: named)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = self.frame.height * 0.5
    }
}
