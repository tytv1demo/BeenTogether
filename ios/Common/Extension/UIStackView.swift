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
    
    func addGradientBackground(backgroundColors: [UIColor] = [], radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        insertSubview(subView, at: 0)
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        subView.setGradientBackground(colors: backgroundColors)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientView = self.subviews.first else { return }
        gradientView.layer.sublayers?.forEach({
            guard let gradientLayer = $0 as? CAGradientLayer else { return }
            gradientLayer.frame = self.bounds
        })
    }
}
