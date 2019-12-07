//
//  LocationNavigator.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol LocationNavigator: AnyObject {
    func popBack()
}

extension LocationViewController: LocationNavigator {
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
