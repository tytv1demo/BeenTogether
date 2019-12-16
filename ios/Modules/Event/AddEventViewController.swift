//
//  AddEventViewController.swift
//  Cupid
//
//  Created by Quan Tran on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

enum AddEventCell {
    case name, caption, location, startDate, endDate, image
}

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and variables

    @IBOutlet weak var addingTable: UITableView!
    @IBOutlet weak var postButton: UIButton!
    
    let cellArray: [AddEventCell] = [.name, .caption, .location, .startDate, .endDate, .image]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
    }
    
    private func setUpTable() {
        addingTable.delegate = self
        addingTable.dataSource = self
        addingTable.register(UINib(nibName: "AddingTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTextTableViewCell")
        addingTable.register(UINib(nibName: "AddingLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingLocationTableViewCell")
        addingTable.register(UINib(nibName: "AddingTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTimeTableViewCell")
    }
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
    }
    
    // MARK: - Table delegate and data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellArray[indexPath.row] {
        case .name:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
 
    private func cellForNameRow(indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
