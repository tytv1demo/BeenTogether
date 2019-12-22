//
//  GradientView.swift
//  Cupid
//
//  Created by Trần Tý on 12/22/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class GradientView: UIView {
    
    private let gradient: CAGradientLayer = CAGradientLayer()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(
        frame: CGRect = .zero,
        colors: [UIColor]
    ) {
        self.init(frame: frame)
        addGradient(colors: colors)
    }
    
    
    func addGradient(colors: [UIColor]) {
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.addSublayer(gradient)
    }
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }
}
