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
    
    let viewModel: EventViewModel = EventViewModel()
    var dataSource: [EventModel] = []
    var isFirstLoad: Bool = true
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        paintLabel()
        let createGesture = UITapGestureRecognizer(target: self, action: #selector(createEventAction))
        createLabel.addGestureRecognizer(createGesture)
        createLabel.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstLoad {
            isFirstLoad = false
            reloadTable()
        }
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
        return dataSource.isEmpty ? 1 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        if dataSource.isEmpty {
            cell.showSkeleton()
            return cell
        }
        
        cell.hideSkeleton()
        
        let event = dataSource[indexPath.row]
        
        var images: [UIImage] = []
        
        if let attachments = event.attachments {
            attachments.forEach { att in
                if let urlString = att.url,
                    let url = URL(string: urlString),
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    images.append(image)
                }
            }
        }
        
        cell.dataSource = images
        cell.desLabel.text = event.description
        
        var dateString = ""
        
        if let startDate = event.startDate {
            dateString = startDate
        }
        
        if let endDate = event.endDate {
            dateString += " - \(endDate)"
        }
        
        cell.dateLabel.text = dateString
        
        return cell
    }
    
    // MARK: - Actions
    
    @objc func createEventAction() {
        let addingVC = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController

        addingVC.dismissCallback = {
            self.reloadTable()
        }
        
        addingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addingVC, animated: true)
    }
    
    private func reloadTable() {
        viewModel.getEvents(completion: { events in
            self.dataSource = events
            DispatchQueue.main.async {
                self.eventTable.reloadData()
            }
        })
    }
}
