//
//  RequestPopupViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 2/17/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

class RequestPopupViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var coupleRepository: CoupleRepository!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coupleRepository = CoupleRepository()
        setupMainView()
        
        phoneTextField.delegate = self
        popupView.transform = CGAffineTransform(translationX: 0, y: (view.frame.height + popupView.frame.height) / 2)
        
        phoneTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         UIView.animate(withDuration: 0.2) {
            self.popupView.transform = CGAffineTransform.identity
         }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.popupView.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height + self.popupView.frame.height) / 2)
        }
    }
    
    // MARK: - Functions
    
    func setupMainView() {
        popupView.layer.cornerRadius = 7
        setupButton()
        addTapGesture(for: self.view)
        addTapGesture(for: popupView)
    }
    
    func setupButton() {
        sendButton.layer.cornerRadius = 5
        laterButton.layer.cornerRadius = 5
        
        sendButton.backgroundColor = Colors.kPink
        laterButton.layer.borderWidth = 1
        laterButton.layer.borderColor = Colors.kPink.cgColor
        
        laterButton.setTitleColor(Colors.kPink, for: .normal)
    }
    
    func addTapGesture(for view: UIView) {
        let tapGesture = UITapGestureRecognizer()
    
        switch view {
        case self.view:
            tapGesture.addTarget(self, action: #selector(self.dismissPopup))
        case popupView:
            tapGesture.addTarget(self, action: #selector(self.dismissKeyBoard))
        default:
            break
        }
        
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc func dismissKeyBoard() {
        phoneTextField.endEditing(true)
    }
    
    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func laterButtonDidTap(_ sender: Any) {
        dismissPopup()
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        guard let phoneNumber = phoneTextField.text else { return }
        
        do {
            let parsedPhoneNumber = try parsePhoneNumber(phoneNumber, "VN")
            AppLoadingIndicator.shared.show()
            coupleRepository.matchRequest(phoneNumber: parsedPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)).done { (success) in
                self.dismissPopup()
                if success {
                    showMessage(title: "Successfully!", message: "Request has been sent!", theme: .success)
                } else {
                    showMessage(title: "Opps!", message: "Unable to send a request to your lover!", theme: .error)
                }
            }.catch { (error) in
                if let apiError = error as? NetWorkApiError, let data = apiError.data, let message = data.message {
                    self.showAlertWithOneOption(title: "Oops!", message: message, optionTitle: "OK")
                } else {
                    self.showAlertWithOneOption(title: "Oops!", message: "Unable to send a request to your lover!", optionTitle: "OK")
                }
            }.finally {
                AppLoadingIndicator.shared.hide()
            }
        } catch {
            self.showAlertWithOneOption(title: "Oops!", message: "This phone number is not available!", optionTitle: "OK")
        }
    }
}

// MARK: - UITextFieldDelegate

extension RequestPopupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.popupView.transform = CGAffineTransform(translationX: 0, y: -50)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
           self.popupView.transform = CGAffineTransform.identity
        }
    }
}
