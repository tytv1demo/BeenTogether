//
//  ImageMessage.swift
//  Cupid
//
//  Created by Trần Tý on 12/1/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import SkeletonView
import ImageViewer

class ImageMessageView: UIView, BaseMessageView {
    
    weak var delegate: MessageViewDelegate?
    
    var messages: [SCMessage]!
    
    var message: SCMessage!
    
    var user: SCUser!
    
    var indexPath: IndexPath!
    
    var rowContentStack: UIStackView!
    
    var image: UIImageView!
    
    var avatar: Avatar!
    
    var statusIndicator: MessageStatusIndicator!
    
    var tapGestureOnBubble: UITapGestureRecognizer?
    
    var tapGestureOnImage: UITapGestureRecognizer?
    
    var dataLoadingStatusObservation: Disposable?
    
    var isConfigedImage: Bool = false
    
    var disposeBag = DisposeBag()
    
    var messageImages: [SCMessage] {
        return messages.filter { $0.type == .image }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        configActions()
    }
    
    func configUI() {
        statusIndicator = MessageStatusIndicator()
        
        image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFill
        
        avatar = Avatar(size: CGSize(width: 25, height: 25), url: "")
        
        let arrangedSubviews: [UIView] = [UIView(), image, avatar, statusIndicator]
        
        rowContentStack = UIStackView(arrangedSubviews: arrangedSubviews)
        rowContentStack.spacing = 8
        rowContentStack.alignment = .bottom
        addSubview(rowContentStack)
        
        statusIndicator.snp.makeConstraints { (make) in
            make.size.equalTo(12)
        }
        
        rowContentStack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        image.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 267))
        }
        
        image.backgroundColor = .groupTableViewBackground
    }
    
    func startConfigForUse() {
        avatar.isHidden = isUserMessage
        avatar.setImage(url: message.author.avatar ?? "")
        avatar.imageView.isHidden = !isLastMessageInGroup
        statusIndicator.isHidden = !isUserMessage
        
        statusIndicator.configWithMessage(message)
        
        rowContentStack.semanticContentAttribute = isUserMessage ? .forceLeftToRight : .forceRightToLeft
        isConfigedImage = false
        checkState()
    }
    
    func checkState() {
        guard let status = try? message.dataLoadingStatus.value() else {
            return
        }
        if status == .done {
            self.configImage()
            return
        }
        dataLoadingStatusObservation = message
            .dataLoadingStatus
            .skip(1)
            .subscribe(onNext: { [weak self] (nextStatus) in
                if nextStatus == .done, self?.image.image == nil {
                    self?.configImage()
                }
            })
    }
    
    func performUpdate() {
        
    }
    
    func configImage() {
        image.image = message.image
//        guard let imageSize = message.image?.size else {
//            return
//        }
//        let ratio: CGFloat = imageSize.height / imageSize.width
//        let width: CGFloat = 150
//        let height: CGFloat = ratio * width
//        let size: CGSize = CGSize(width: width, height: height)
//        image.snp.remakeConstraints { (make) in
//            make.size.equalTo(size)
//        }
    }
    
    func configActions() {
        tapGestureOnBubble = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGestureOnBubble!)
        
        tapGestureOnImage = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        image.addGestureRecognizer(tapGestureOnImage!)
        image.isUserInteractionEnabled = true
    }
    
    @objc func didTap(_ sender: UIView?) {
        delegate?.messageView(didTap: self, onView: sender)
    }
    
    @objc func tapOnImage() {
        guard let topViewController = UIApplication.topViewController() else { return }
        let currentIndex = messageImages.firstIndex { $0 == message! } ?? 0
        let galleryView = GalleryViewController(startIndex: currentIndex, itemsDataSource: self, configuration: [.deleteButtonMode(.none)])
        topViewController.presentImageGallery(galleryView)
    }
    
    func prepareForReuse() {
        dataLoadingStatusObservation?.dispose()
        statusIndicator.prepareForReuse()
        image.image = nil
    }
    
    deinit {
        dataLoadingStatusObservation?.dispose()
    }
}

extension ImageMessageView: GalleryItemsDataSource {
    func itemCount() -> Int {
        return messageImages.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        let message = messageImages[index]
        return .image { completion in
            let resolve = { (status: SCMessageDataLoadingStaus) -> Bool in
                if status == .done || message.image != nil {
                    completion(message.image)
                    return true
                }
                return false
            }
            
            guard let status = try? message.dataLoadingStatus.value() else { return }
            
            if resolve(status) { return }
            
            message.dataLoadingStatus.subscribe(onNext: { status in
                _ = resolve(status)
            }).disposed(by: self.disposeBag)
        }
    }
}
