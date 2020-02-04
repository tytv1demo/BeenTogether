//
//  LoginViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase
import PhoneNumberKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var phoneNumberImage: UIImageView!
    @IBOutlet weak var otpImage: UIImageView!
    // MARK: - Properties
    
    var isOTPViewHidden = true
    var verifyID = ""
    var userRepository = UserRepository()
    var loginViewModel: LoginViewModel!
    var createVC: CreateViewController!
    var phoneNumberKit: PhoneNumberKit!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberKit = PhoneNumberKit()
        
        phoneNumberTextField.text = ""
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
        setupImageView()
        setupSignInButton()
        setupOTPView()
        addTapGestureForView()
    }
    
    func setupImageView() {
        phoneNumberImage.setImage(UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25)))
        otpImage.setImage(UIImage.fontAwesomeIcon(name: .mobileAlt, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25)))
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
        otpTextField.becomeFirstResponder()
    }
    
    func getOTPCode(_ phoneNumber: String) {
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
    
    func signIn(_ phoneNumber: String) {
        guard let otpCode = otpTextField.text else { return }
        
        let firebaseToken = ["key": self.verifyID, "code": otpCode]
        let userParam = SignInParams(phoneNumber: phoneNumber, firebaseToken: firebaseToken)
        AppLoadingIndicator.shared.show()
        loginViewModel.signIn(with: userParam).done { (canLogin) in
            if canLogin {
                AppLoadingIndicator.shared.hide()
                self.goToHomeScreen()
            }
        }.catch({ (error) in
            if let apiError = error as? NetWorkApiError, let data = apiError.data, let message = data.message {
                self.showAlertWithOneOption(title: "Oops!", message: message, optionTitle: "OK")
            } else {
                self.showAlertWithOneOption(title: "Oops!", message: "Unable to sign in!", optionTitle: "OK")
            }
            AppLoadingIndicator.shared.hide()
            
        })
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        do {
            let parsedPhoneNumber = try parsePhoneNumber(phoneNumber, "VN")
            if signInButton.titleLabel?.text == "SIGN IN" {
                signIn(parsedPhoneNumber)
            } else {
                getOTPCode(parsedPhoneNumber)
            }
        } catch {
            self.showAlertWithOneOption(title: "Oops!", message: "Your phone number is not available!", optionTitle: "OK")
        }
    }
    
    @IBAction func createAccountButtonDidTap(_ sender: Any) {
        self.goToCreateScreen()
    }
}

// MARK: - UITextViewDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            signInButton.setTitle("VERIFY PHONE NUMBER", for: .normal)
            otpTextField.text = nil
            isOTPViewHidden = true
            otpView.isHidden = true
        }
    }
}
