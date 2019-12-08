//
//  GalleryImage.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class GalleryImageCell: UICollectionViewCell {
    
    static let kCellIdentifer: String = "GalleryImageCell"
    
    var scrollContentView: UIScrollView!
    
    var imageView: UIImageView!
    
    var isChoosingAction: Bool = false
    
    var imageSubscription: Disposable?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    
    func initUI() {
        scrollContentView = UIScrollView()
        scrollContentView.isUserInteractionEnabled = false
        contentView.addSubview(scrollContentView)
        scrollContentView.delegate = self
        
        scrollContentView.minimumZoomScale = 1
        scrollContentView.maximumZoomScale = 4.0
        scrollContentView.zoomScale = 1
        
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        scrollContentView.addSubview(imageView)
    }
    
    func makeConstraints() {
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func onTapImage() {
        if isChoosingAction {
            UIView.animate(withDuration: 0.2) {
                self.scrollContentView.zoomScale = 1
            }
            imageView.removeBlurEffect()
        } else {
            UIView.animate(withDuration: 0.2) {
                self.scrollContentView.zoomScale = 1.5
            }
            imageView.addBlurEffect()
        }
        isChoosingAction = !isChoosingAction
    }
    
    func configCellWithAsset(_ asset: GalleryAsset) {
        imageSubscription = asset.image.subscribe(onNext: { [unowned self] (image) in
            self.imageView.image = image
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageSubscription?.dispose()
    }
}

extension GalleryImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
