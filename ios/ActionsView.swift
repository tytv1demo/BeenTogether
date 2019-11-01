//
//  ActionsView.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class ActionsView: UIView {
  
  var stack: UIStackView!
  
  var cameraButton: UIButton!
  
  var galeryButton: UIButton!
  
  var microButton: UIButton!
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initUI()
  }
  
  func initUI() {
    
    cameraButton = UIButton()
    cameraButton.setImage(UIImage(named: "camera"), for: [])
    
    galeryButton = UIButton()
    galeryButton.setImage(UIImage(named: "camera"), for: [])
    
    microButton = UIButton()
    microButton.setImage(UIImage(named: "camera"), for: [])
    
    stack = UIStackView(arrangedSubviews: [cameraButton, galeryButton, microButton])

    stack.spacing = 16
    stack.alignment = .center
    addSubview(stack)
    
    stack.snp.makeConstraints { (m) in
      m.edges.equalTo(self).inset(8)
    }
  }
}
