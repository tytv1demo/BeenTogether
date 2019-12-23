//
//  EventViewController.swift
//  Cupid
//
//  Created by Quan Tran on 12/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var createLabel: UILabel!
    
    var viewModel: EventViewModel = EventViewModel()
    var dataSource: [EventModel] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        paintLabel()
        let createGesture = UITapGestureRecognizer(target: self, action: #selector(createEventAction))
        createLabel.addGestureRecognizer(createGesture)
        createLabel.isUserInteractionEnabled = true
    }
    
    private func setUpTable() {
        reloadTable()
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
    }
    
    private func paintLabel() {
        let str = "How is your love today?"
        let attrStr = NSMutableAttributedString(string: str)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#D7636D"), range: NSMakeRange(str.count - 11, 4))
        createLabel.attributedText = attrStr
    }
    
    // MARK: - Table data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - Actions
    
    @objc func createEventAction() {
        let addingVC = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController

        addingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addingVC, animated: true)
    }
    
    private func reloadTable() {
        dataSource = viewModel.getEvents(completion: {
            DispatchQueue.main.async {
                self.eventTable.reloadData()
            }
        })
    }
}
