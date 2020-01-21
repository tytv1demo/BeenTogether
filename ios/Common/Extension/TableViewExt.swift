//
//  TableViewExtension.swift
//  ViperExample
//
//  Created by Phuong Nguyen on 11/15/17.
//  Copyright © 2017 Phuong Nguyen. All rights reserved.
//

import UIKit

private let kActivityViewTag = 9998

protocol ReusableView: class {
    static var nibName: String { get }
}

extension ReusableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.nibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nibName)")
        }
        return cell
    }
    
}

extension UITableView {
    
    func addActivityFooter() {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
        activityIndicatorView.tag = kActivityViewTag
        activityIndicatorView.hidesWhenStopped = true
        self.tableFooterView = activityIndicatorView
    }
    
    func removeActivityFooter() {
        if let activityIndicatorView = self.viewWithTag(kActivityViewTag) as? UIActivityIndicatorView {
            activityIndicatorView.removeFromSuperview()
        }
    }
    
    func startAnimatingActivityFooter() {
        if let activityIndicatorView = self.viewWithTag(kActivityViewTag) as? UIActivityIndicatorView {
            activityIndicatorView.startAnimating()
        }
    }
    
    func stopAnimatingActivityFooter() {
        if let activityIndicatorView = self.viewWithTag(kActivityViewTag) as? UIActivityIndicatorView {
            activityIndicatorView.stopAnimating()
        }
    }
    
}

extension UITableView {
    
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    @discardableResult
    func setEmptyMessage(_ message: String, buttonTitle: String = "Đồng ý", onButtonPress: (() -> Void)? = nil) -> CollectionEmptyView {
        let messageLabel = CollectionEmptyView(frame: bounds, message: message, buttonTitle: buttonTitle, onButtonPress: onButtonPress)
        self.backgroundView = messageLabel
        return messageLabel
    }

    func removeEmptyView() {
        self.backgroundView = nil
    }
}
