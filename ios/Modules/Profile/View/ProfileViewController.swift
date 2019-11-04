//
//  ProfileViewController.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {

    var viewModel: ProfileViewModelProtocol! { get set }

}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    var viewModel: ProfileViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}