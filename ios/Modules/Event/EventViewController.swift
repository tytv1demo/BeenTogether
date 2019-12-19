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
        paintLabel()
        let createGesture = UITapGestureRecognizer(target: self, action: #selector(createEventAction))
        createLabel.addGestureRecognizer(createGesture)
    }
    
    private func setUpTable() {
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
    
    // MARK: - Actions
    
    @objc func createEventAction() {
        let addingVC = UIStoryboard(name: "AddEventViewController", bundle: nil).instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController

        addingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addingVC, animated: true)
    }
}
