//
//  AddEventViewController.swift
//  Cupid
//
//  Created by Quan Tran on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum AddEventCell {
    case name, caption, location, startDate, endDate, image
}

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var addingTable: UITableView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var tableViewToBottomConstraints: NSLayoutConstraint!
    
    let cellArray: [AddEventCell] = [.name, .caption, .location, .startDate, .endDate, .image]
    var newEvent: EventModel = EventModel()
    let viewModel: EventViewModel = EventViewModel()
    var eventAddedCallback: (() -> Void)?
    var didFinishUploadingImages: Bool = false {
        didSet {
            if shouldStartPostAfter {
                postEvent()
            }
        }
    }
    var shouldStartPostAfter: Bool = false
    var uploadData: [Data] = []
    var uploadedImage: [String] = []
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewToBottomConstraints.constant = checkIsIphoneX() ? 75 : 50
        
        newEvent.attachments = []
        setUpTable()
        newEvent.creator = ""
        
        self.addingTable.estimatedRowHeight = 64.0
        self.addingTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBannerView()
        setupInterstitialView()
        interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ads: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func setupInterstitialView() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-8922649592904313/9299700284" //"ca-app-pub-3940256099942544/6300978111"
        //ca-app-pub-8922649592904313/5268590972
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        bannerView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(checkIsIphoneX() ? 25 : 0)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpTable() {
        addingTable.delegate = self
        addingTable.dataSource = self
        addingTable.register(UINib(nibName: "AddingNameTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingNameTableViewCell")
        addingTable.register(UINib(nibName: "AddingTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTextTableViewCell")
        addingTable.register(UINib(nibName: "AddingLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingLocationTableViewCell")
        addingTable.register(UINib(nibName: "AddingTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingTimeTableViewCell")
        addingTable.register(UINib(nibName: "AddingImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddingImagesTableViewCell")
    }
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        let warningAlert = UIAlertController(title: nil, message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        warningAlert.addAction(UIAlertAction(title: "Yes, please", style: .destructive, handler: { _ in
            self.uploadedImage.forEach { image in
                self.viewModel.removeImages(url: image)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        warningAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(warningAlert, animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        
        guard newEvent.name != nil, newEvent.startDate != nil, newEvent.attachments!.count > 0 else {
            let alert = UIAlertController(title: "Oops!", message: "An event must have at least name, start date and attachments. Please provide before post!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        AppLoadingIndicator.shared.show()
        
        if !didFinishUploadingImages, !uploadData.isEmpty {
            shouldStartPostAfter = true
        } else {
            postEvent()
        }
    }
    
    private func postEvent() {
        viewModel.create(event: newEvent) {
            AppLoadingIndicator.shared.hide()
            self.navigationController?.popViewController(animated: true)
            self.eventAddedCallback?()
        }
    }
    
    // MARK: - Table delegate and data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellArray[indexPath.row] {
        case .name:
            return cellForNameRow(indexPath: indexPath)
        case .caption:
            return cellForCaptionRow(indexPath: indexPath)
        case .location:
            return cellForLocationRow(indexPath: indexPath)
        case .startDate:
            return cellForStartDateRow(indexPath: indexPath)
        case .endDate:
            return cellForEndDateRow(indexPath: indexPath)
        case .image:
            return cellForImagesRow(indexPath: indexPath)
        }
    }
    
    private func cellForNameRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTextTableViewCell", for: indexPath) as? AddingTextTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didEndEditingCallback = { text in
            self.newEvent.name = text
        }
        
        cell.addingTextField.placeholder = "Event's name"
        return cell
    }
    
    private func cellForCaptionRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingNameTableViewCell", for: indexPath) as? AddingNameTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didChangeTextCallback = { text in
            self.newEvent.description = text
        }
        
        return cell
    }
    
    private func cellForLocationRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingLocationTableViewCell", for: indexPath) as? AddingLocationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didEndEditingCallback = { text in
            self.newEvent.location = text
        }
        
        return cell
    }
    
    private func cellForStartDateRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTimeTableViewCell", for: indexPath) as? AddingTimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didSelectDate = { date in
            self.newEvent.startDate = date
        }
        
        cell.titleLabel.text = "When did it start?"
        return cell
    }
    
    private func cellForEndDateRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingTimeTableViewCell", for: indexPath) as? AddingTimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.didSelectDate = { date in
            self.newEvent.endDate = date
        }
        
        cell.titleLabel.text = "When did it end?"
        return cell
    }
    
    private func cellForImagesRow(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = addingTable.dequeueReusableCell(withIdentifier: "AddingImagesTableViewCell", for: indexPath) as? AddingImagesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.parentVC = self
        cell.didSelectImageCallback = { data in
            self.didFinishUploadingImages = false
            self.uploadData.append(data)
            
            self.viewModel.upload(image: data) { url in
                let media = MediaModel(url: url, type: MediaType.IMAGE.rawValue)
                if self.newEvent.attachments != nil {
                    self.newEvent.attachments?.append(media)
                } else {
                    self.newEvent.attachments = [media]
                }
                self.uploadedImage.append(url)
                cell.dataSource.append(data)
                self.didFinishUploadingImages = true
                DispatchQueue.main.async {
                    cell.imagesCollection.reloadData()
                }
            }
        }
        
        cell.didDeleteCallback = { index in
            self.uploadData.remove(at: index)
            self.viewModel.removeImages(url: self.uploadedImage[index])
            self.newEvent.attachments?.remove(at: index)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cellArray.count - 1 {
            return view.bounds.height / 2
        }
        
        return UITableView.automaticDimension
    }
}


extension AddEventViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

func checkIsIphoneX() -> Bool {
    let device = UIDevice()
    if device.userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1792, 2426, 2436, 2688:
            return true
        default:
            return false
        }
    }
    
    return false
}
