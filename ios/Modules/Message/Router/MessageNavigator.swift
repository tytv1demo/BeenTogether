//
//  MessageNavigator.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol MessageNavigator: AnyObject {

}

extension MessageViewController: MessageNavigator {
    func goToLocationScreen() {
        let locationViewController = LocationViewController()
        locationViewController.viewModel = LocationViewModel(coupleModel: viewModel.coupleModel)
        self.navigationController?.pushViewController(locationViewController, animated: true)
    }
}
