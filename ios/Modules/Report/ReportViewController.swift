//
//  ReportViewController.swift
//  Cupid
//
//  Created by Dung Nguyen on 2/4/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import SnapKit

class ReportViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var reportTitleButtons: [UIButton]!
    @IBOutlet var reportDetailButtons: [UIButton]!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var reportDetailView: UIView!
    @IBOutlet weak var detailQuestionLabel: UILabel!
    
    // MARK: - Properties
    
    // Title of report
    var reportTitleStrings = ["Harassment", "Suicide or Self-Injury", "Hate Speech"]
    var reportTitleStringsHasDetail = ["Pretending to Be Someone", "Sharing Inappropriate Things", "Unauthorized Sales", "Other"]
    
    // Detail of report
    var pretendingDetails = ["Pretending to Be Someone", "Who are they pretending to be?", "Me", "A Friend", "A Celebrity", "Someone Else"]
    var sharingDetails = ["Sharing Inappropriate Things", "What types of things are they sharing?", "Nudity", "Pornography", "Violent or Graphic Content"]
    var unauthSalesDetails = ["Unauthorized Sales", "What are they trying to sell?", "Guns", "Drugs"]
    var otherDetails = ["Other", "Is it one of these things?", "Technical Issue", "Spam", "False News", "Hacked", "Something Else"]
    
    var reportTitleString = ""
    var isFromMessageVC: Bool!
    var userRepository: UserRepository!
    var coupleModel: CoupleModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRepository = UserRepository()
        coupleModel = CoupleModel(userInfo: AppUserData.shared.userInfo)
        
        setupMainView()
    }
    
    // MARK: - Functions
    
    func setupMainView() {
        setupSendButton()
        setupReportButtons()
        addTargetForButton()
        hideReportDetailView()
        resetDetailButtonStatus()
    }
    
    func resetDetailButtonStatus() {
        for item in reportDetailButtons {
            item.isHidden = true
            item.isEnabled = false
            item.backgroundColor = Colors.kLightGray
            item.setTitleColor(.black, for: .normal)
        }
    }
    
    func addTargetForButton() {
        for item in reportTitleButtons {
            item.addTarget(self, action: #selector(reportTitleButtonDidTap), for: [.touchUpInside])
        }
        
        for item in reportDetailButtons {
            item.addTarget(self, action: #selector(reportDetailButtonDidTap), for: [.touchUpInside])
        }
    }
    
    func setupSendButton() {
        sendButton.layer.cornerRadius = 25
        disableSendButton()
    }
    
    func showReportDetailView() {
        reportDetailView.isHidden = false
    }
    
    func hideReportDetailView() {
        reportDetailView.isHidden = true
    }
    
    func disableSendButton() {
        sendButton.backgroundColor = Colors.kLightGray
        sendButton.setTitleColor(.gray, for: .normal)
        sendButton.isEnabled = false
    }
    
    func enableSendButton() {
        sendButton.backgroundColor = Colors.kPink
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.isEnabled = true
    }
    
    func setupReportButtons() {
        for item in reportTitleButtons {
            item.backgroundColor = Colors.kLightGray
            item.layer.cornerRadius = item.bounds.size.height / 3
        }
        
        for item in reportDetailButtons {
            item.backgroundColor = Colors.kLightGray
            item.layer.cornerRadius = item.bounds.size.height / 3
        }
    }
    
    @objc func reportTitleButtonDidTap(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if reportTitleStrings.contains(text) {
            enableSendButton()
            hideReportDetailView()
        } else if reportTitleStringsHasDetail.contains(text) {
            resetDetailButtonStatus()
            disableSendButton()
            showReportDetailView()
            addTextForButton(text)
        }
        
        for item in reportTitleButtons {
            item.backgroundColor = Colors.kLightGray
            item.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = Colors.kPink
        sender.setTitleColor(.white, for: .normal)
        
        reportTitleString = text
    }
    
    func addText(buttons: [UIButton], strings: [String], length: Int) {
        var count = 2
        
        for button in buttons {
            for index in count..<length {
                button.setTitle("    \(strings[index])    ", for: .normal)
                button.isHidden = false
                button.isEnabled = true
                count += 1
                break
            }
        }
    }
    
    func addTextForButton(_ text: String) {
        if pretendingDetails.contains(text) {
            detailQuestionLabel.text = pretendingDetails[1]
            addText(buttons: reportDetailButtons, strings: pretendingDetails, length: 6)
        } else if sharingDetails.contains(text) {
            detailQuestionLabel.text = sharingDetails[1]
            addText(buttons: reportDetailButtons, strings: sharingDetails, length: 5)
        } else if unauthSalesDetails.contains(text) {
            detailQuestionLabel.text = unauthSalesDetails[1]
            addText(buttons: reportDetailButtons, strings: unauthSalesDetails, length: 4)
        } else if otherDetails.contains(text) {
            detailQuestionLabel.text = otherDetails[1]
            addText(buttons: reportDetailButtons, strings: otherDetails, length: 7)
        }
    }
    
    @objc func reportDetailButtonDidTap(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        for item in reportDetailButtons {
            item.backgroundColor = Colors.kLightGray
            item.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = Colors.kPink
        sender.setTitleColor(.white, for: .normal)
        enableSendButton()
        
        reportTitleString += ": \(text)"
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        let type = isFromMessageVC ? "MESSAGE" : "EVENT"
        
        AppLoadingIndicator.shared.show()
        userRepository.report(phoneNumber: coupleModel.friendInfo?.phoneNumber ?? "0123456789", reason: reportTitleString, type: type).done { (success) in
            AppLoadingIndicator.shared.hide()
            
            if success {
                let actionSheet = UIAlertController(title: "Thanks!", message: "We'e received your feedback.", preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
                    self.dismiss()
                }))
                    
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                self.showAlertWithOneOption(title: "Opps!", message: "Unable to send your feedback! Please, try again later.", optionTitle: "OK")
            }
        }.catch { (err) in
            AppLoadingIndicator.shared.hide()
            self.showAlertWithOneOption(title: "Opps!", message: err.localizedDescription, optionTitle: "OK")
        }
    }
}
