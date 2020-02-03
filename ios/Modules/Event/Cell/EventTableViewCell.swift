//
//  EventTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, UIScrollViewDelegate, FSPagerViewDelegate, FSPagerViewDataSource {
    
    @IBOutlet weak var imageCollection: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    var emptyView: UIImageView!
    
    var dataSource: [MediaModel] = [] {
        didSet {
            if dataSource.isEmpty {
                let defaultImage = UIImage(named: "default-event")
                emptyView = UIImageView(image: defaultImage)
                
                imageCollection.insertSubview(emptyView, at: 0)
                emptyView.frame = imageCollection.bounds
            }
            emptyView?.removeFromSuperview()
            imageCollection.reloadData()
            pageControl.numberOfPages = dataSource.count <= 1 ? 0 : dataSource.count
        }
    }
    
    let boundScreen = UIScreen.main.bounds
    var optionCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpPager()
    }
    
    func setUpPager() {
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        imageCollection.itemSize = CGSize(width: boundScreen.width, height: boundScreen.width * 9 / 16)
        imageCollection.transformer = FSPagerViewTransformer(type: .depth)
        
        pageControl.contentHorizontalAlignment = .center
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.setFillColor(.lightGray, for: .normal)
        pageControl.setFillColor(Colors.kPink, for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - FSPager data source and delegate
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dataSource.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ImageCell", at: index)
        guard let url = dataSource[index].url, let resource = URL(string: url) else {
            return cell
        }
        cell.imageView?.kf.setImage(with: resource)
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
    
    @IBAction func optionAction(_ sender: UIButton) {
        optionCallback?()
    }
}
