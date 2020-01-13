//
//  UIStackView.swift
//  Cupid
//
//  Created by Trần Tý on 1/13/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension UIStackView {
    func addBackground(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
    }
}
