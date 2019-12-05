//
//  EventViewController.swift
//  Cupid
//
//  Created by Quan Tran on 12/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var eventCollection: UICollectionView!
    
    // TO-DO: delete test
    let testImgs: [UIImage?] = [
        UIImage(named: "test_img1"),
        UIImage(named: "test_img2"),
        UIImage(named: "test_img3"),
        UIImage(named: "test_img4"),
        UIImage(named: "test_img5"),
        UIImage(named: "test_img6"),
        UIImage(named: "test_img7"),
        UIImage(named: "test_img8"),
        UIImage(named: "test_img9"),
        UIImage(named: "test_img10")
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollection()
    }
    
    private func setUpCollection() {
        eventCollection.delegate = self
        eventCollection.dataSource = self
        eventCollection.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
    }
    
    // MARK: - Collection data source and delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 158, height: 189)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imgView.image = testImgs[indexPath.row]
        
        return cell
    }
}
