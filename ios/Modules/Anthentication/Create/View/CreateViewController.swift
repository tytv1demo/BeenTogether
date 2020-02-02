//
//  CreateViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/13/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Firebase

class CreateViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var phoneNumberImage: UIImageView!
    @IBOutlet weak var nameImage: UIImageView!
    @IBOutlet weak var otpImage: UIImageView!
    
    var isOTPViewHidden = true
    var verifyID = ""
    var createViewModel: CreateViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        nameTextField.delegate = self
        
        createViewModel = CreateViewModel()
        setupMainView()
        
    }
    
    func setupMainView() {
        setupBackgroundImage()
        setupOTPView()
        setupTextField()
        setupImageView()
        setupCreateButton()
        addTapGestureForView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupImageView() {
        phoneNumberImage.setImage(UIImage.fontAwesomeIcon(name: .phone, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25)))
        nameImage.setImage(UIImage.fontAwesomeIcon(name: .userAlt, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25)))
        otpImage.setImage(UIImage.fontAwesomeIcon(name: .mobileAlt, style: .solid, textColor: .white, size: CGSize(width: 25, height: 25)))
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
        otpTextField.becomeFirstResponder()
    }
    
    func getOTPCode(_ phoneNumber: String) {
        AppLoadingIndicator.shared.show()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verifyID, err) in
            if err == nil {
                guard let verifyID = verifyID else { return }
                self.verifyID = verifyID
                self.showOTPView()
                self.createButton.setTitle("SIGN UP", for: .normal)
                AppLoadingIndicator.shared.hide()
            } else {
                AppLoadingIndicator.shared.hide()
                self.showAlertWithOneOption(title: "Oops!", message: "Unable to get OTP code!", optionTitle: "OK")
            }
        }
    }
    
    func signUp(_ phoneNumber: String) {
        guard let otpCode = otpTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        let firebaseToken = ["key": self.verifyID, "code": otpCode]
        let userParam = SignUpParams(phoneNumber: phoneNumber, name: name, firebaseToken: firebaseToken)
        
        AppLoadingIndicator.shared.show()
        createViewModel.signUp(with: userParam).done { (canSignUp) in
            if canSignUp {
                AppLoadingIndicator.shared.hide()
                self.goToHomeScreen()
            }
        }.catch({ (_) in
            AppLoadingIndicator.shared.hide()
            self.showAlertWithOneOption(title: "Oops!", message: "Unable to sign up!", optionTitle: "OK")
        })
    }
    
    @IBAction func createButtonDidTap(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        do {
            let parsedPhoneNumber = try parsePhoneNumber(phoneNumber, "VN")
            if createButton.titleLabel?.text == "SIGN UP" {
                signUp(parsedPhoneNumber)
            } else {
                getOTPCode(parsedPhoneNumber)
            }
        } catch {
            self.showAlertWithOneOption(title: "Oops!", message: "Your phone number is not available!", optionTitle: "OK")
        }
    }
    
    @IBAction func backToLoginButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension CreateViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            createButton.setTitle("VERIFY PHONE NUMBER", for: .normal)
            otpTextField.text = nil
            isOTPViewHidden = true
            otpView.isHidden = true
            stackViewHeight.constant = isOTPViewHidden ? 124 : 186
        }
    }
}
