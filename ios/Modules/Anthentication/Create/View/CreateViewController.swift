//
//  CreateViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class CreateViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var otpView: UIView!
    
    var isOTPViewHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        
        
    }
    
    func setupMainView() {
        setupBackgroundImage()
        setupOTPView()
        setupTextField()
        setupCreateButton()
        addTapGestureForView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupOTPView() {
        otpView.isHidden = isOTPViewHidden
        stackViewHeight.constant = 124
    }
    
    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login_bg.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupTextField() {
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        otpTextField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
    }
    
    func setupCreateButton() {
        createButton.layer.cornerRadius = 25
    }
    
    func addTapGestureForView() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleDismissKeyBoard))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismissKeyBoard() {
        phoneNumberTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        otpTextField.resignFirstResponder()
    }
    
    func showOTPView() {
        isOTPViewHidden = !isOTPViewHidden
        otpView.isHidden = isOTPViewHidden
        stackViewHeight.constant = isOTPViewHidden ? 124 : 186
    }
    
    @IBAction func createButtonDidTap(_ sender: Any) {
        showOTPView()
    }
    
    @IBAction func backToLoginButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
