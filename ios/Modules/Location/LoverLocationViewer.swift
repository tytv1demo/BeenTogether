//
//  LoverLocationViewer.swift
//  Cupid
//
//  Created by Trần Tý on 12/7/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import RxSwift
import MapKit

class LoverLocationViewer: UIView {
    
    // MARK: - Properties
    
    var addressLabel: UILabel!
    var lastUpdateTimeLabel: UILabel!
    var imageView: UIImageView!
    var location: BehaviorSubject<CustomLocation?>!
    var disposeBag: DisposeBag!
    
    // MARK: Initial
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainViews()
        disposeBag = DisposeBag()
    }
    
    convenience init(location: BehaviorSubject<CustomLocation?>) {
        self.init(frame: .zero)
        self.location = location
        
        subcribe()
    }
    
    // MARK: - Functions
    
    func setupMainViews() {
        setupBackgroundView()
        setupLabels()
        setupImageView()
        makeConstraints()
    }
    
    func setupBackgroundView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 8)
        layer.shadowRadius = 5
    }
    
    func setupImageView() {
        imageView = UIImageView(image: UIImage(named: "ic_location"))
        imageView.sizeToFit()
        
        addSubview(imageView)
    }
    
    func setupLabels() {
        addressLabel = UILabel()
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.text = "Fetching your lover's location..."
        addressLabel.numberOfLines = 3
        
        lastUpdateTimeLabel = UILabel()
        lastUpdateTimeLabel.textColor = .black
        lastUpdateTimeLabel.font = UIFont.italicSystemFont(ofSize: 15)
        lastUpdateTimeLabel.textAlignment = .right
        lastUpdateTimeLabel.showSkeleton()

        addSubview(addressLabel)
        addSubview(lastUpdateTimeLabel)
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView).offset(25)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        lastUpdateTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Actions

    func subcribe() {
        location.subscribe(onNext: { [unowned self] (data) in
            guard let location = data else { return }
            
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            
            self.getAddressFromLatLong(latitude: lat, longitude: lng, completion: { value in
                self.addressLabel.text = value
                self.lastUpdateTimeLabel.hideSkeleton()
                self.lastUpdateTimeLabel.text = "Last updated in \(location.lastUpdate.format("HH:mm - yyyy-MMM-dd"))"
            })
            
        }).disposed(by: disposeBag)
    }
    
    func getAddressFromLatLong(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String) -> Void) {
        var addressString = ""

        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion("Could not get your lover's address!")
            } else {
                guard let placemarks = placemarks else {
                    completion(addressString)
                    return
                }
                
                if let placemark = placemarks.first {
                    if let addressNumber = placemark.subThoroughfare {
                        addressString += addressNumber + " "
                    }
                    
                    if let street = placemark.thoroughfare {
                        addressString += street
                    }
                    
                    if let city = placemark.locality {
                        addressString += ", " + city
                    }
                    
                    if let country = placemark.country {
                        addressString += ", " + country
                    }
                    
                    completion("Your lover's location is near: \(addressString).")
                }
            }
        })
    }
}
