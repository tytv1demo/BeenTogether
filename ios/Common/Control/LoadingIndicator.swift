//
//  LoadingIndicator.swift
//  Cupid
//
//  Created by Trần Tý on 1/13/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator: UIView {
    
    var indicator: NVActivityIndicatorView!
    
    var contentStackView: UIStackView!
    
    var messageLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        indicator = NVActivityIndicatorView(frame: CGRect(origin: bounds.origin, size: CGSize(width: 54, height: 54)), type: .circleStrokeSpin, color: .red, padding: 5)
        
        messageLabel = UILabel()
        messageLabel.text = "Loading ..."
        messageLabel.textColor = .white
        
        contentStackView = UIStackView(arrangedSubviews: [indicator, messageLabel])
        addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        contentStackView.addBackground(backgroundColor: UIColor.black.withAlphaComponent(0.5), radiusSize: 8 )
        contentStackView.layer.masksToBounds = true
        contentStackView.layer.cornerRadius = 8
        contentStackView.spacing = 8
        
        contentStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indicator.startAnimating()
    }
}
