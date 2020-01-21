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

enum GalleryImageCellAction {
    case send, alarm
}

protocol GalleryImageCellDelegate: AnyObject {
    func galleryImageCell(didSelect cell: GalleryImageCell, action: GalleryImageCellAction)
}

class GalleryImageCell: UICollectionViewCell {
    
    static let kCellIdentifer: String = "GalleryImageCell"
    
    weak var delegate: GalleryImageCellDelegate?
    
    var scrollContentView: UIScrollView!
    
    var imageView: UIImageView!
    
    var sendButton: CircleButton!
    
    var timerButton: CircleButton!
    
    var actionStackView: UIStackView!
    
    var imageSubscription: Disposable?
    
    var asset: GalleryAsset!
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        addActions()
        
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
        imageView.isUserInteractionEnabled = true
        scrollContentView.addSubview(imageView)
        
        sendButton = CircleButton(size: 52, title: "Send")
        sendButton.isUserInteractionEnabled = true

        timerButton = CircleButton(size: 52, title: "Alarm")
        timerButton.isHidden = true
        
        actionStackView = UIStackView(arrangedSubviews: [sendButton, timerButton])
        actionStackView.alignment = .center
        actionStackView.spacing = 8
        actionStackView.isUserInteractionEnabled = true
        
        scrollContentView.addSubview(actionStackView)
        actionStackView.bringSubviewToFront(actionStackView)
        actionStackView.isHidden = true
    }
    
    func makeConstraints() {
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        actionStackView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    func addActions() {
        sendButton.addTarget(self, action: #selector(onSendButtonTap), for: [.touchUpInside])
        timerButton.addTarget(self, action: #selector(onTimerButtonTap), for: [.touchUpInside])
    }
    
    @objc func onSendButtonTap() {
        delegate?.galleryImageCell(didSelect: self, action: .send)
    }
    
    @objc func onTimerButtonTap() {
        delegate?.galleryImageCell(didSelect: self, action: .alarm)
    }
    
    func showActions() {
        UIView.animate(withDuration: 0.2) {
            self.scrollContentView.zoomScale = 1.5
        }
        imageView.addBlurEffect()
        actionStackView.isHidden = false
    }
    
    func hideActions() {
        UIView.animate(withDuration: 0.2) {
            self.scrollContentView.zoomScale = 1
        }
        imageView.removeBlurEffect()
        actionStackView.isHidden = true
    }
    
    func configCellWithAsset(_ asset: GalleryAsset) {
        self.asset = asset
        imageSubscription = asset.image.subscribe(onNext: { [unowned self] (image) in
            self.imageView.image = image
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageSubscription?.dispose()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if actionStackView.isHidden {
            return super.hitTest(point, with: event)
        }
        for view in actionStackView.subviews {
            let convertPoint = view.convert(point, from: self)
            let viewPoint = view.hitTest(convertPoint, with: event)
            if viewPoint != nil {
                return viewPoint
            }
        }
        return super.hitTest(point, with: event)
    }
    
    deinit {
        sendButton.removeTarget(self, action: #selector(onSendButtonTap), for: [.touchUpInside])
        timerButton.removeTarget(self, action: #selector(onTimerButtonTap), for: [.touchUpInside])
    }
}

extension GalleryImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
