//
//  DatingViewController.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol DatingViewControllerProtocol: AnyObject {

    var viewModel: DatingViewModelProtocol! { get set }

}

class DatingViewController: UIViewController, DatingViewControllerProtocol {

    var viewModel: DatingViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}