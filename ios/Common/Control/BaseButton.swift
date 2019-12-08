//
//  BaseButton.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class BaseButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBehaviors()
    }
    
    private func setBehaviors() {
        setGradientBackground()
        layer.masksToBounds = true
        layer.cornerRadius = 8
        
        backgroundColor = Colors.kPink
        dropShadow()
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
