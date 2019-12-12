//
//  LoginViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var topForgotToBotSignInViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var isOTPViewHidden = true
    var userRepository = UserRepository()
    var loginViewModel: LoginViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.text = "0365021305"
        
        loginViewModel = LoginViewModel()
        setupMainView()
    }
    
    // MARK: - Functions
    
    func setupMainView() {
        setupBackgroundImage()
        setupTextField()
        setupSignInButton()
        setupOTPView()
        addTapGestureForView()
    }
    
    func setupOTPView() {
        otpView.isHidden = isOTPViewHidden
        topForgotToBotSignInViewConstraint.constant = -45
    }
    
    func setupTextField() {
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
        otpTextField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
    }
    
    func setupSignInButton() {
        signInButton.layer.cornerRadius = 25
    }
    
    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "login_bg.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func addTapGestureForView() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleDismissKeyBoard))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismissKeyBoard() {
        phoneNumberTextField.resignFirstResponder()
        otpTextField.resignFirstResponder()
    }
    
    func showOTPView() {
        isOTPViewHidden = !isOTPViewHidden
        otpView.isHidden = isOTPViewHidden
        
        UIView.animate(withDuration: 1) {
            self.topForgotToBotSignInViewConstraint.constant = self.isOTPViewHidden ? -45 : 17
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        showOTPView()
        
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        loginViewModel.signIn(with: phoneNumber)
    }
    
    @IBAction func createAccountButtonDidTap(_ sender: Any) {
        print("create")
    }
    
    @IBAction func forgotButtonDidTap(_ sender: Any) {
        print("forgot")
    }
    
}
