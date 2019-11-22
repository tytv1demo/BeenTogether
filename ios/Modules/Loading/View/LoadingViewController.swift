//
//  LoadingViewController.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol LoadingViewControllerProtocol: AnyObject {

    var viewModel: LoadingViewModelProtocol! { get set }

}

class LoadingViewController: UIViewController, LoadingViewControllerProtocol {

    var viewModel: LoadingViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
