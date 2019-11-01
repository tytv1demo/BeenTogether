//
//  SmartChartContainer.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit

class SmartChart: UIView {
  
  var messageTableView: MessageTableView!
  var inputToolBar: InputToolBar!
  
  var data: Array<SCMessage> = [] {
    didSet {
      messageTableView.messages = self.data
    }
  }
  
  var user: SCUser!
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init (frame: CGRect = .zero, user: SCUser) {
    self.init(frame: frame)
    self.user = user
    setupUI()
  }
  
  func setupUI() {
    messageTableView = MessageTableView(user: user)
    addSubview(messageTableView)
    
    inputToolBar = InputToolBar()
    addSubview(inputToolBar)
    
    messageTableView.snp.makeConstraints { (m) in
      m.top.equalTo(self)
      m.trailing.equalTo(self)
      m.leading.equalTo(self)
      m.bottom.equalTo(inputToolBar.snp.top)
    }
    
    inputToolBar.snp.makeConstraints { (m) in
      m.bottom.equalTo(self)
      m.trailing.equalTo(self)
      m.leading.equalTo(self)
      m.height.equalTo(self.inputToolBar.height)
    }
  }
}
