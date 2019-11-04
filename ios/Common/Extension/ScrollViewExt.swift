//
//  ScrollViewExt.swift
//  ViperExample
//
//  Created by Phuong Nguyen on 11/15/17.
//  Copyright © 2017 Phuong Nguyen. All rights reserved.
//

import UIKit

private let kRefreshViewTag             = 9999
private let kViewNoneDataTag            = 8888

extension UIScrollView {
    
    func addRefreshControl(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        refreshControl.tag = kRefreshViewTag
        self.addSubview(refreshControl)
    }
    
    func removeRefreshControl() {
        if let refreshControl = self.viewWithTag(kRefreshViewTag) as? UIRefreshControl {
            refreshControl.removeFromSuperview()
        }
    }
    
    func beginRefreshing() {
        if let refreshControl = self.viewWithTag(kRefreshViewTag) as? UIRefreshControl {
            refreshControl.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        if let refreshControl = self.viewWithTag(kRefreshViewTag) as? UIRefreshControl {
            refreshControl.endRefreshing()
        }
    }
    
}
