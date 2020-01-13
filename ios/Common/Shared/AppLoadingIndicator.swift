//
//  AppLoadingIndicator.swift
//  Cupid
//
//  Created by Trần Tý on 1/13/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import UIKit


class AppLoadingIndicator {
    static let shared = AppLoadingIndicator()
    
    var indicator: LoadingIndicator = LoadingIndicator()
    
    func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else { return }
            self.indicator.frame = window.bounds
            self.indicator.layer.opacity = 0
            window.addSubview(self.indicator)
            UIView.animate(withDuration: 0.2) {
                self.indicator.layer.opacity = 1
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.2,
                animations: { self.indicator.layer.opacity = 0 },
                completion: { _ in self.indicator.removeFromSuperview()}
            )
        }
    }

}
