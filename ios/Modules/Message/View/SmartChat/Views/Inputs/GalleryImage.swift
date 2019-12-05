//
//  GalleryImage.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class GalleryImageCell: UICollectionViewCell {
    
    static let kCellIdentifer: String = "GalleryImageCell"
    
    var scrollContentView: UIScrollView!
    
    var imageView: UIImageView!
    
    var isChoosingAction: Bool = false
    
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
            make.size.equalToSuperview()
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
    
    func configCellWith(image: UIImage) {
        imageView.image = image
    }
}

extension GalleryImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
