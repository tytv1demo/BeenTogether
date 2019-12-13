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
    
    // MARK: - Properties
    
    var isOTPViewHidden = true
    var userRepository = UserRepository()
    var loginViewModel: LoginViewModel!
    var createVC: CreateViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.text = "0365021305"
        
        loginViewModel = LoginViewModel()
        setupMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        showOTPView()
        
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        _ = loginViewModel.signIn(with: phoneNumber).done { (result) in
            if result {
                self.goToHomeScreen()
            } else {
                
            }
        }
    }
    
    @IBAction func createAccountButtonDidTap(_ sender: Any) {
        self.goToCreateScreen()
    }
}
