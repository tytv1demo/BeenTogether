//
//  EventTableViewCell.swift
//  Cupid
//
//  Created by Quan Tran on 12/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import ImageViewer
import Kingfisher

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
                return
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
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        imageCollection.dataSource = self
        imageCollection.delegate = self
        imageCollection.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        imageCollection.itemSize = CGSize(width: boundScreen.width, height: boundScreen.width * 9 / 16)
        imageCollection.transformer = FSPagerViewTransformer(type: .overlap)
        
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
        cell.imageView?.contentMode = .scaleAspectFill
        
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let galleryView = GalleryViewController(startIndex: index, itemsDataSource: self, configuration: [.deleteButtonMode(.none)])
        topViewController.presentImageGallery(galleryView)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    @IBAction func optionAction(_ sender: UIButton) {
        optionCallback?()
    }
}

extension EventTableViewCell: GalleryItemsDataSource {
    func itemCount() -> Int {
        return dataSource.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return .image { [weak self] completion in
            guard let url = URL(string: self?.dataSource[index].url ?? "") else {
                return
            }
            KingfisherManager.shared.retrieveImage(with: url) { (result) in
                guard let image = try? result.get() else { return }
                completion(image.image)
            }
        }
    }
}
