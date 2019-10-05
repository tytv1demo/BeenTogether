//
//  DashboardView.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit
import SnapKit

class DashboardViewController: UIViewController {
  
  // MARK: - Views
  lazy var yellowBox: UIView = {
    let box = UIView()
    box.backgroundColor = .yellow
    box.layer.cornerRadius = 40
    box.layer.masksToBounds = true
//    box.layer.borderWidth = 2
//    box.layer.borderColor = UIColor.red.cgColor
    return box
  }()
  
  lazy var orangeBox: UIView = {
    let box = UIView()
    box.backgroundColor = .orange
    box.layer.cornerRadius = 20
    box.layer.masksToBounds = true
    return box
  }()
  
  lazy var orangeBox1: UIView = {
    let box = UIView()
    box.backgroundColor = .orange
    box.layer.cornerRadius = 20
    box.layer.masksToBounds = true
    return box
  }()
  
  lazy var addButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 33
    button.setTitle("+", for: .normal)
    button.backgroundColor = .black
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOpacity = 0.3
    button.layer.shadowRadius = 1
    button.layer.shadowOffset = CGSize(width: 3, height: 3)
    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    runAutoLayout()
  }
  
  // MARK: - Functions
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(orangeBox)
    view.addSubview(orangeBox1)
    view.addSubview(yellowBox)
    view.addSubview(addButton)
  }
  
  private func runAutoLayout() {
    yellowBox.snp_makeConstraints { (make) in
      make.width.equalTo(80)
      make.height.equalTo(yellowBox.snp_width)
      make.center.equalTo(view)
    }
    
    orangeBox.snp_makeConstraints { (make) in
      make.width.equalTo(38)
      make.height.equalTo(orangeBox.snp_width)
      make.center.equalTo(view).offset(-38)
    }
    
    orangeBox1.snp_makeConstraints { (make) in
      make.width.equalTo(38)
      make.height.equalTo(orangeBox1.snp_width)
      make.centerX.equalTo(view).offset(38)
      make.centerY.equalTo(view).offset(-38)
    }
    
    addButton.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(66)
      make.height.equalTo(addButton.snp_width)
      make.bottom.equalTo(view.snp_bottom).offset(-20)
      make.right.equalTo(view.snp_right).offset(-20)
    }
  }
  
  // MARK: - Actions
  @objc func addButtonDidTap() {
    print("did tap !")
  }
}
