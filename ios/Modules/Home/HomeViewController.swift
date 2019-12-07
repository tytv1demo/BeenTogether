//
//  Home.swift
//  BeenTogether
//
//  Created by Trần Tý on 10/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import SnapKit

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var heartIconLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var avatarView: Avatar!
    @IBOutlet weak var leftAvatar: Avatar!
    @IBOutlet weak var rightAvatar: Avatar!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCoutingLabel: UILabel!
    @IBOutlet weak var leftDaysLabel: UILabel!
    @IBOutlet weak var rightDayLabel: UILabel!
   
    // MARK: Properties
    
    let startDateString = "01-03-2016"
    var startDate = Date()
    let currentDate = Date()
    let dateFormater = DateFormatter()
    var dateCouted = 0
    var selectedImageView: UIImageView?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        setupLabelColor()
       
        avatarView.setImage(url: "https://thuthuatnhanh.com/wp-content/uploads/2019/10/avatar-me-than-tuong.jpg")
        leftAvatar.setImage(url: "https://thuvientoc.com/wp-content/uploads/2018/08/kieu-toc-dep-cua-ngoc-trinh-2.jpg")
        rightAvatar.setImage(url: "https://thuvientoc.com/wp-content/uploads/2018/08/kieu-toc-dep-cua-ngoc-trinh-2.jpg")
        
        // Avatar
        setupLeftAvatar()
        setupRightAvatar()
        
        // Progress View
        setupData()
        setupDateCountingLabel()
        setupLeftRightDayLabels(numOfDay: dateCouted)
        setupProgressView()
        
    }
    
    // MARK: Actions
    
    // MARK: Functions
    
    func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homeBackground.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupLabelColor() {
        titleLabel.textColor = Colors.kPink
        dateCoutingLabel.textColor = Colors.kPink
        leftDaysLabel.textColor = Colors.kPink
        rightDayLabel.textColor = Colors.kPink
    }
    
    func setupProgressView() {
        progressView.progressTintColor = Colors.kPink
        progressView.trackTintColor = Colors.kPink
        progressView.progress = getProgress(number: dateCouted)
        heartIconLeftContraint.constant = CGFloat(progressView.progress) * progressView.frame.width
    }
    
    func setupData() {
        dateFormater.dateFormat = "dd-MM-yyyy"
        startDate = dateFormater.date(from: startDateString)!
        dateCouted = countDays(from: startDate)
    }
    
    func countDays(from startDate: Date?) -> Int {
        if let startDate = startDate, startDate < currentDate {
            return currentDate.days(sinceDate: startDate) ?? 0
        }
        
        return 0
    }
    
    func setupLeftRightDayLabels(numOfDay: Int) {
        leftDaysLabel.text = String(getLeftRightNumbers(numOfDay).leftNumber)
        rightDayLabel.text = String(getLeftRightNumbers(numOfDay).rightNumber)
    }
    
    func setupDateCountingLabel() {
        let unitString = dateCouted > 1 ? " days" : " day"
        dateCoutingLabel.text = String(dateCouted) + unitString
    }

    func getLeftRightNumbers(_ number: Int) -> (leftNumber: Int, rightNumber: Int) {
        if number == 0 || number % 100 == number {
            return (0, 100)
        } else if number % 100 == 0 {
            return (number - 100, number)
        } else {
            let naturalPart = number / 100
            if naturalPart == 1 {
                return (100, 200)
            } else {
                return (naturalPart * 100, (naturalPart + 1) * 100)
            }
        }
    }
    
    func getProgress(number: Int) -> Float {
        if number <= 100 {
            return Float(number) / 100
        } else {
            let remainingPart = number % 100
            return Float(remainingPart) / 100
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupLeftAvatar() {
        let tapGueture = UITapGestureRecognizer()
        tapGueture.addTarget(self, action: #selector(chooseImage(_:)))
        leftAvatar.imageView.addGestureRecognizer(tapGueture)
        leftAvatar.imageView.isUserInteractionEnabled = true
    }
    
    func setupRightAvatar() {
        let tapGueture = UITapGestureRecognizer()
        tapGueture.addTarget(self, action: #selector(chooseImage(_:)))
        rightAvatar.imageView.addGestureRecognizer(tapGueture)
        rightAvatar.imageView.isUserInteractionEnabled = true
    }
    
    @objc func chooseImage(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerVC.sourceType = .camera
                self.present(imagePickerVC, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            imagePickerVC.sourceType = .photoLibrary
            self.present(imagePickerVC, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        selectedImageView = imageView
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView!.image = image
            picker.dismiss(animated: true, completion: {
                self.selectedImageView = nil
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            self.selectedImageView = nil
        })
    }
}
