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
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        AppLoadingIndicator.shared.show()
        dismissPopup()
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
