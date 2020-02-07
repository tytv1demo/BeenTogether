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
    var didAddListener: Bool = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setUpTable()
        paintLabel()
        let createGesture = UITapGestureRecognizer(target: self, action: #selector(createEventAction))
        createLabel.addGestureRecognizer(createGesture)
        createLabel.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didAddListener {
            addListenerEvent()
        }
    }
    
    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBackground.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func setUpTable() {
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
    }
    
    private func paintLabel() {
        createLabel.text = "Share your memorable event"
    }
    
    private func addListenerEvent() {
        viewModel.listenToAddEvent { event in
            self.isFirstLoad = false
            if let event = event {
                self.didAddListener = true
                self.dataSource.append(event)
            }
            
            self.dataSource.sort {
                if let eStart = $0.startDate, let fStart = $1.startDate {
                    let eDate = Date(fromString: eStart, format: .custom(kEventDateFormat))
                    let fDate = Date(fromString: fStart, format: .custom(kEventDateFormat))
                    
                    return eDate > fDate
                } else {
                    return true
                }
            }
            self.eventTable.reloadData()
        }
    }
    
    // MARK: - Table data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFirstLoad ? 3 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        if isFirstLoad {
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        if dataSource.isEmpty {
            return cell
        }
        
        let event = dataSource[indexPath.row]
        
        cell.desLabel.text = event.description
        cell.nameLabel.text = event.name
        
        var dateString = ""
        
        if let startDate = event.startDate {
            dateString = startDate
        }
        
        if let endDate = event.endDate, !endDate.isEmpty {
            dateString += " - \(endDate)"
        }
        
        cell.dateLabel.text = dateString
        
        cell.optionCallback = {
            let optionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            optionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            optionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.showDeleteAlert(event: event)
            }))
            
            optionAlert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
                self.showReportVC()
            }))
            self.present(optionAlert, animated: true, completion: nil)
        }
    
        cell.dataSource = event.attachments ?? []
        return cell
    }
    
    // MARK: - Actions
    
    @objc func createEventAction() {
        let addingVC = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        
        addingVC.hidesBottomBarWhenPushed = true
        addingVC.eventAddedCallback = reloadTable
        
        navigationController?.pushViewController(addingVC, animated: true)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.eventTable.reloadData()
        }
    }
    
    private func showDeleteAlert(event: EventModel) {
        let deleteAlert = UIAlertController(title: "Warning", message: "You are about to delete this memory and can't be undone. Are you sure?", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "Yes, please.", style: .default, handler: { _ in
            self.viewModel.delete(event: event) { id in
                self.dataSource.removeAll(where: { $0.id == id })
                self.reloadTable()
            }
        }))
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    private func showReportVC() {
        let reportVC = ReportViewController(nibName: "ReportViewController", bundle: nil)
        reportVC.isFromMessageVC = false
        reportVC.modalPresentationStyle = .formSheet
        reportVC.modalTransitionStyle = .coverVertical
        
        present(reportVC, animated: true, completion: nil)
    }
}
