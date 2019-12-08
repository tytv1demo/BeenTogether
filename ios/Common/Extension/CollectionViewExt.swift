//
//  CollectionViewExtension.swift
//  ViperExample
//
//  Created by Phuong Nguyen on 11/15/17.
//  Copyright © 2017 Phuong Nguyen. All rights reserved.
//

import UIKit

extension UICollectionViewCell: ReusableView {
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.nibName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nibName)")
        }
        return cell
    }
    
    func setEmptyMessage(_ message: String, buttonTitle: String = "Đồng ý", onButtonPress: (() -> Void)? = nil) {
        let messageLabel = CollectionEmptyView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 32, height: self.bounds.size.height), message: message, buttonTitle: buttonTitle, onButtonPress: onButtonPress)
        self.backgroundView = messageLabel
    }

    func removeEmptyView() {
        self.backgroundView = nil
    }
    
}
