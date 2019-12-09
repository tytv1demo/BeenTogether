//
//  EventViewController.swift
//  Cupid
//
//  Created by Quan Tran on 12/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventTable: UITableView!
    
    // TO-DO: delete test
    let testImgs: [UIImage] = [
        UIImage(named: "test_img1")!,
        UIImage(named: "test_img2")!,
        UIImage(named: "test_img3")!,
        UIImage(named: "test_img4")!,
        UIImage(named: "test_img5")!,
        UIImage(named: "test_img6")!,
        UIImage(named: "test_img7")!,
        UIImage(named: "test_img8")!,
        UIImage(named: "test_img9")!,
        UIImage(named: "test_img10")!
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
    }
    
    private func setUpTable() {
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
    }
    
    // MARK: - Table data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testImgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dataSource = testImgs
        cell.pageControl.numberOfPages = testImgs.count
        
        return cell
    }
}
