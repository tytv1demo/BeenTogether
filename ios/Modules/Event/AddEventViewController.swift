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
    var newEvent: EventModel = EventModel()
    let viewModel: EventViewModel = EventViewModel()
    var eventAddedCallback: (() -> Void)?
    var didFinishUploadingImages: Bool = false {
        didSet {
            if shouldStartPostAfter {
                postEvent()
            }
        }
    }
    var shouldStartPostAfter: Bool = false
    var uploadData: [Data] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newEvent.attachments = []
        setUpTable()
        // TO-DO: add creator ava
        newEvent.creator = ""
    }
    
    private func setUpTable() {
        addingTable.delegate = self
        addingTable.dataSource = self
        addingTable.register(UINib(nibName: "AddingTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTextTableViewCell")
        addingTable.register(UINib(nibName: "AddingLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingLocationTableViewCell")
        addingTable.register(UINib(nibName: "AddingTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTimeTableViewCell")
        addingTable.register(UINib(nibName: "AddingImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingImagesTableViewCell")
    }
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        // TO-DO: Delete uploaded images
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        AppLoadingIndicator.shared.show()
        
        if !didFinishUploadingImages, !uploadData.isEmpty {
            shouldStartPostAfter = true
        } else {
            postEvent()
        }
    }
    
    private func postEvent() {
        viewModel.create(event: newEvent) {
            AppLoadingIndicator.shared.hide()
            self.navigationController?.popViewController(animated: true)
            self.eventAddedCallback?()
        }
    }
    
    // MARK: - Table delegate and data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellArray[indexPath.row] {
        case .name:
            return cellForNameRow(indexPath: indexPath)
        case .caption:
            return cellForCaptionRow(indexPath: indexPath)
        case .location:
            return cellForLocationRow(indexPath: indexPath)
        case .startDate:
            return cellForStartDateRow(indexPath: indexPath)
        case .endDate:
            return cellForEndDateRow(indexPath: indexPath)
        case .image:
            return cellForImagesRow(indexPath: indexPath)
        }
    }
    
    private func cellForNameRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTextTableViewCell", for: indexPath) as? AddingTextTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didEndEditingCallback = { text in
            self.newEvent.name = text
        }
        
        cell.addingTextField.placeholder = "Event's name"
        return cell
    }
    
    private func cellForCaptionRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTextTableViewCell", for: indexPath) as? AddingTextTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didEndEditingCallback = { text in
            self.newEvent.description = text
        }
        
        cell.addingTextField.placeholder = "Caption"
        return cell
    }
    
    private func cellForLocationRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingLocationTableViewCell", for: indexPath) as? AddingLocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didEndEditingCallback = { text in
            self.newEvent.location = text
        }
        
        return cell
    }
    
    private func cellForStartDateRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTimeTableViewCell", for: indexPath) as? AddingTimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didSelectDate = { date in
            self.newEvent.startDate = date
        }
        
        cell.titleLabel.text = "When did it start?"
        return cell
    }
    
    private func cellForEndDateRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTimeTableViewCell", for: indexPath) as? AddingTimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didSelectDate = { date in
            self.newEvent.endDate = date
        }
        
        cell.titleLabel.text = "When did it end?"
        return cell
    }
    
    private func cellForImagesRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingImagesTableViewCell", for: indexPath) as? AddingImagesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.parentVC = self
        cell.didSelectImageCallback = { data in
            self.didFinishUploadingImages = false
            self.uploadData.append(data)
            
            self.viewModel.upload(image: data) { url in
                let media = MediaModel(url: url, type: MediaType.IMAGE.rawValue)
                if self.newEvent.attachments != nil {
                    self.newEvent.attachments?.append(media)
                } else {
                    self.newEvent.attachments = [media]
                }
                self.didFinishUploadingImages = true
            }
        }
        return cell
    }
    
    // TO-DO: Clear uploaded data, can't post if doesnt have enough info
}
