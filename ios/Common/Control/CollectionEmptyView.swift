//
//  CollectionEmptyView.swift
//  Cupid
//
//  Created by Trần Tý on 12/8/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Kingfisher

class CollectionEmptyView: UIView {
    
    var container: UIStackView!
    
    var contentView: UIStackView!
    
    var imageView: UIImageView!
    
    var messageLabel: UILabel!
    
    var button: BaseButton!
    
    var message: String?
    
    var onButtonPress: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        addActions()
    }
    
    convenience init (frame: CGRect = CGRect.zero, message: String?, buttonTitle: String?, onButtonPress: (() -> Void)?) {
        self.init(frame: frame)
        messageLabel.text = message
        self.onButtonPress = onButtonPress
        button.setTitle(buttonTitle, for: [])
    }
    
    func setupUI() {
        imageView = UIImageView()
//        imageView.image = UIImage(named: "CupidLogo")
        let url = URL(string: "https://purepng.com/public/uploads/large/purepng.com-trash-empty-iconsymbolsiconsapple-iosiosios-8-iconsios-8-721522596129yc9hm.png")
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 80, height: 80))
        imageView.kf.setImage(with: url, options: [.processor(resizingProcessor)])
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 3
        
        button = BaseButton()
        
        contentView = UIStackView(arrangedSubviews: [imageView, messageLabel, button])
        contentView.alignment = .center
        contentView.axis = .vertical
        contentView.spacing = 8
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        
        container = UIStackView(arrangedSubviews: [contentView, UIView()])
        container.axis = .vertical
        addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func addActions() {
        button.addTarget(self, action: #selector(onButtonTouchUpInside), for: [.touchUpInside])
    }
    
    @objc func onButtonTouchUpInside() {
        onButtonPress?()
    }
    
    deinit {
        button.removeTarget(self, action: #selector(onButtonTouchUpInside), for: [.touchUpInside])
    }
}
