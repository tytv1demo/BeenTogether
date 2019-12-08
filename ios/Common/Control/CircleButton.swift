//
//  CircleButton.swift
//  Cupid
//
//  Created by Trần Tý on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class CircleButton: UIButton {
    
    var size: CGFloat!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect = .zero, size: CGFloat, title: String) {
        self.init(frame: frame)
        snp.makeConstraints { (make) in
            make.size.equalTo(size)
        }
        setTitle(title, for: [])
        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height * 0.5
    }
}
