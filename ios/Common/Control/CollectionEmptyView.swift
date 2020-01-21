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
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "CupidLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = Colors.kPink.cgColor
        imageView.layer.borderWidth = 2
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 3
        messageLabel.textColor = UIColor.darkGray.withAlphaComponent(0.8)
        
        button = BaseButton()
        
        contentView = UIStackView(arrangedSubviews: [imageView, messageLabel, button])
        contentView.alignment = .center
        contentView.axis = .vertical
        contentView.spacing = 8
        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        
        container = UIStackView(arrangedSubviews: [contentView])
        container.axis = .vertical
        container.alignment = .center
        container.isLayoutMarginsRelativeArrangement = true
        addSubview(container)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(self.snp.width).multipliedBy(0.3)
        }
        
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }
    }
    
    func addActions() {
        button.addTarget(self, action: #selector(onButtonTouchUpInside), for: [.touchUpInside])
    }
    
    @objc func onButtonTouchUpInside() {
        onButtonPress?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = bounds.width * 0.15
    }
    
    deinit {
        button.removeTarget(self, action: #selector(onButtonTouchUpInside), for: [.touchUpInside])
    }
}
