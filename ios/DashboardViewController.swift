//
//  DashboardView.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import YogaKit

class DashboardViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    let testView: UILabel = UILabel()
    
    view.addSubview(testView)
    testView.text = "Testts"
    testView.textColor = .black
    testView.configureLayout { (l) in
      l.isEnabled = true
      l.marginTop = YGValue(value: 20, unit: .percent)
      l.alignSelf = .center
    }
    view.yoga.isEnabled = true
    view.yoga.applyLayout(preservingOrigin: true)
  }
}
