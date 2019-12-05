//
//  MessageStatusIndicator.swift
//  Cupid
//
//  Created by Trần Tý on 12/2/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import SwiftyGif
import RxSwift

class MessageStatusIndicator: UIView {
    
    var image: UIImageView!
    
    var message: SCMessage!
    
    var statusSubcription: Disposable?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func configImage(forStatus status: SCMessageStatus) {
        
        if image != nil {
            image.removeFromSuperview()
        }
        
        image = UIImageView()
        switch status {
        case .timer:
            break
        case .sending:
            self.image.setGifFromURL(URL(string: "https://icon-library.net/images/spinner-icon-gif/spinner-icon-gif-23.jpg")!)
        case .sent:
            self.image.image = UIImage(named: "done-tick")
        case .seen:
            self.image.kf.setImage(with: URL(string: "https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg")!)
        }
        addSubview(image)
        
        image.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = frame.size.width * 0.5
    }
    
    func configWithMessage(_ message: SCMessage) {
        statusSubcription = message.status.subscribe(onNext: { [unowned self] (status) in
            self.configImage(forStatus: status)
        })
    }
    
    func prepareForReuse() {
        statusSubcription?.dispose()
    }
}
