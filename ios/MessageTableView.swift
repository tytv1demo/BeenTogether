//
//  MessageTableView.swift
//  Cupid
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class MessageTableView: UIView {
  var tableView: UITableView!
  
  var messages: Array<SCMessage> = [] {
    didSet {
      tableView.reloadData()
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
    tableView = UITableView()
    addSubview(tableView)
    
    tableView.snp.makeConstraints { (m) in
      m.edges.equalTo(self)
    }
    
    tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.CELL_IDENTIFY)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
  }
  
}
extension MessageTableView: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.CELL_IDENTIFY, for: indexPath) as! MessageCell
    
    cell.configWith(messages: messages, at: indexPath, andUser: user)
    
    return cell
  }
  
}
