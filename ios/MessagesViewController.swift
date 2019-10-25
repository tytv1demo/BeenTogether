//
//  MessagesViewController.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class MessageViewController: UIViewController {
  var gpsButton: UIButton!
  var phoneButton: UIButton!
  
  var loverNameLabel: UILabel!
  var loverAvatar: Avatar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    settupNavigation()
  }
  
  func settupNavigation(){
    navigationController?.navigationBar.backgroundColor = .white
    
    gpsButton = UIButton(type: .custom)
    gpsButton.setImage(UIImage(named: "gps"), for: [])
    let gpsTabBarItem = UIBarButtonItem(customView: gpsButton)
    
    phoneButton = UIButton(type: .custom)
    phoneButton.setImage(UIImage(named: "phone"), for: [])
    let phoneTabBarButton = UIBarButtonItem(customView: phoneButton)
    
    navigationItem.rightBarButtonItems = [gpsTabBarItem, phoneTabBarButton]
    
    loverAvatar = Avatar(url: "https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg")
    let avatarBarItem = UIBarButtonItem(customView: loverAvatar)
    
    loverNameLabel = UILabel()
    loverNameLabel.textColor = UIColor(rgb: 0xFA7268)
    let nameLabelTabBarItem = UIBarButtonItem(customView: loverNameLabel)
    loverNameLabel.text = "Lover"
    
    navigationItem.leftBarButtonItems = [avatarBarItem, nameLabelTabBarItem]
  }
  
  @objc func onGpsButtonPress(){
    
  }
  
  @objc func onPhoneButtonPress(){
    
  }
}
