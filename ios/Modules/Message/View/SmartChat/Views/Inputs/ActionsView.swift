//
//  ActionsView.swift
//  Cupid
//
//  Created by Trần Tý on 10/27/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import FontAwesome_swift

protocol ActionViewDelegate: AnyObject {
    func actionView(onOpenCamera actionView: ActionsView)
    func actionView(onOpenGallery actionView: ActionsView)
    func actionView(onStateChanged actionView: ActionsView)
}

enum ActionsViewState {
    case expand, collapse
}

class ActionsView: UIView {
    
    var state: ActionsViewState = .expand {
        didSet {
            updateBehavior()
            delegate?.actionView(onStateChanged: self)
        }
    }
    
    var stack: UIStackView!
    
    var cameraButton: UIButton!
    
    var galleryButton: UIButton!
    
    var microButton: UIButton!
    
    var expandButton: UIButton!
    
    weak var delegate: ActionViewDelegate?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initActions()
        updateBehavior()
    }
    
    func initUI() {
        
        cameraButton = UIButton()
        let cameraImage = UIImage.awesomeIcon(name: .camera)
        cameraButton.setImage(cameraImage, for: [])
        
        galleryButton = UIButton()
        let galleryImage = UIImage.awesomeIcon(name: .image)
        galleryButton.setImage(galleryImage, for: [])
        
        microButton = UIButton()
        let microImage = UIImage.awesomeIcon(name: .microphone)
        microButton.setImage(microImage, for: [])
        
        expandButton = UIButton()
        expandButton.setImage(UIImage(named: "Plus"), for: [])
        
        stack = UIStackView(arrangedSubviews: [cameraButton, galleryButton, microButton, expandButton])
        
        stack.spacing = 16
        stack.alignment = .center
        addSubview(stack)
        
        stack.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func initActions() {
        galleryButton.addTarget(self, action: #selector(onGalleryButtonTouchUpInside), for: [.touchUpInside])
        expandButton.addTarget(self, action: #selector(expand), for: [.touchUpInside])
    }
    
    func updateBehavior() {
        let isExpanded: Bool = state == .expand
        UIView.animate(withDuration: 0.2) {
            self.cameraButton.isHidden = !isExpanded
            self.galleryButton.isHidden = !isExpanded
            self.microButton.isHidden = !isExpanded
            self.expandButton.isHidden = isExpanded
        }
    }
    
    @objc func expand() {
        self.state = .expand
    }
    
    @objc func onGalleryButtonTouchUpInside() {
        delegate?.actionView(onOpenGallery: self)
    }
}
