//
//  LoginViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Properties
    
    var isOTPViewHidden = true
    var verifyID = ""
    var userRepository = UserRepository()
    var loginViewModel: LoginViewModel!
    var createVC: CreateViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.text = "0963777597"
        phoneNumberTextField.delegate = self
        
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
    
    func getOTPCode() {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        AppLoadingIndicator.shared.show()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verifyID, err) in
            if err == nil {
                guard let verifyID = verifyID else { return }
                self.verifyID = verifyID
                self.signInButton.setTitle("SIGN IN", for: .normal)
                self.showOTPView()
                AppLoadingIndicator.shared.hide()
            } else {
                AppLoadingIndicator.shared.hide()
                self.showAlertWithOneOption(title: "Oops!", message: "Unable to get OTP code!", optionTitle: "OK")
            }
        }
    }
    
    func signIn() {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let otpCode = otpTextField.text else { return }
        
        let firebaseToken = ["key": self.verifyID, "code": otpCode]
        let userParam = SignInParams(phoneNumber: phoneNumber, firebaseToken: firebaseToken)
        AppLoadingIndicator.shared.show()
        loginViewModel.signIn(with: userParam).done { (canLogin) in
            if canLogin {
                AppLoadingIndicator.shared.hide()
                self.goToHomeScreen()
            }
        }.catch({ (_) in
            AppLoadingIndicator.shared.hide()
            self.showAlertWithOneOption(title: "Oops!", message: "Unable to sign in!", optionTitle: "OK")
        })
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
//        if signInButton.titleLabel?.text == "SIGN IN" {
//            signIn()
//        } else {
//            getOTPCode()
//        }
        signIn()
    }
    
    @IBAction func createAccountButtonDidTap(_ sender: Any) {
        self.goToCreateScreen()
    }
}

// MARK: - UITextViewDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            otpTextField.text = nil
            isOTPViewHidden = true
            otpView.isHidden = true
        }
    }
}
