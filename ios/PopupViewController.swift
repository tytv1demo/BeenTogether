//
//  PopupViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 12/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import PromiseKit

class PopupViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    
    var homeViewModel: HomeViewModel!
    var isLeft: Bool?
    weak var delegate: HomViewControllerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        setupMainView()
        
        nameTextField.delegate = self
        popupView.transform = CGAffineTransform(translationX: 0, y: (view.frame.height + popupView.frame.height) / 2)
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
        okButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        
        okButton.backgroundColor = Colors.kPink
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.kPink.cgColor
        
        cancelButton.setTitleColor(Colors.kPink, for: .normal)
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
        nameTextField.endEditing(true)
    }
    
    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismissPopup()
    }
    
    @IBAction func okButtonDidTap(_ sender: Any) {
        guard let name = nameTextField.text, name.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        
        let trimedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let personId = isLeft! ? "0349055710" : "0365021305"
        
        homeViewModel.refPersonName(name: trimedName, personId: personId).done { (success) in
            if success {
                self.delegate?.updateNameLabelCallBack(name: trimedName)
            }
        }.catch { (_) in
            self.showAlertWithOneOption(title: "Opps", message: "Unable to change this name!", optionTitle: "OK")
        }
        
        dismissPopup()
    }
}

// MARK: - UITextFieldDelegate

extension PopupViewController: UITextFieldDelegate {
    
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
