//
//  LoverLocationViewer.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class LoverLocationViewer: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 8)
        layer.shadowRadius = 5
        
        layer.shouldRasterize = true
    }
}
