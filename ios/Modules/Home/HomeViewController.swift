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
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    
    // MARK: Properties
    
    var selectedImageView: UIImageView?
    var userRepository = UserRepository()
    var homeViewModel: HomeViewModel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        setupMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Functions
    
    func setupMainView() {
        setupBackgroundImage()
        setupLabelColor()
        setupAvatar()
        setupLeftAvatar()
        setupRightAvatar()
        setupProgressView()
        setupDataForLabels()
        addTapGestureForLabel(leftNameLabel)
        addTapGestureForLabel(rightNameLabel)
    }
    
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
        progressView.progress = homeViewModel.getProgress()
        heartIconLeftContraint.constant = CGFloat(progressView.progress) * progressView.frame.width
    }
    
    func setupDataForLabels() {
        dateCoutingLabel.text = homeViewModel.dateCountedString
        leftDaysLabel.text = String(homeViewModel.getLeftRightNumbers().leftNumber)
        rightDayLabel.text = String(homeViewModel.getLeftRightNumbers().rightNumber)
    }
    
    func setupAvatar() {
        let url = "https://thuthuatnhanh.com/wp-content/uploads/2019/10/avatar-me-than-tuong.jpg"
        avatarView.setImage(url: url)
    }
    
    func setupLeftAvatar() {
        let url = "https://thuthuatnhanh.com/wp-content/uploads/2019/10/avatar-me-than-tuong.jpg"
        leftAvatar.setImage(url: url)
        addTapGestureForView(leftAvatar.imageView)
    }
    
    func setupRightAvatar() {
        let url = "https://thuthuatnhanh.com/wp-content/uploads/2019/10/avatar-me-than-tuong.jpg"
        rightAvatar.setImage(url: url)
        addTapGestureForView(rightAvatar.imageView)
    }
    
    func addTapGestureForLabel(_ label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(presentChangeNamePopUp))
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentChangeNamePopUp() {
        print("HIHI")
    }
    
    func addTapGestureForView(_ view: UIView) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(chooseImage(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc func chooseImage(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
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
}

// MARK: - UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
