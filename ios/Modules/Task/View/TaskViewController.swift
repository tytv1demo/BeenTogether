//
//  TaskViewController.swift
//  Cupid
//
//  Created by Lucas Lee on 11/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

protocol TaskViewControllerProtocol: AnyObject {

    var viewModel: TaskViewModelProtocol! { get set }

}

class TaskViewController: UIViewController, TaskViewControllerProtocol {

    var viewModel: TaskViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}