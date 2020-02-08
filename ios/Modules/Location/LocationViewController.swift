//
//  LocationViewController.swift
//  Cupid
//
//  Created by Trần Tý on 12/5/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import Kingfisher

protocol LocationViewControllerType: UIViewController {
    
    var view: UIView! { get }
    
    var mapView: MKMapView! { get }
    
    var currentAnotation: MapViewAnotaion! { get }
    
    var loverAnotation: MapViewAnotaion! { get }
    
    var loverLocationViewer: LoverLocationViewer! { get }
    
    var viewModel: LocationViewModel! { get set }
    
    func settupViews()
    
    func makeConstrainsts()
}

class LocationViewController: UIViewController, LocationViewControllerType {
    var mapView: MKMapView!
    
    var backButton: UIButton!
    
    var phoneButton: UIButton!
    
    var gpsButton: UIButton!
    
    var loverNameLabel: UILabel!
    
    var loverAvatar: Avatar!
    
    var currentAnotation: MapViewAnotaion!
    
    var loverAnotation: MapViewAnotaion!
    
    var loverLocationViewer: LoverLocationViewer!
    
    var directionRoute: MKRoute?
    
    var viewModel: LocationViewModel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settupNavigation()
        settupViews()
        makeConstrainsts()
        subscribeViewModel()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.coupleModel.friendId == "local" {
            let actionSheet = UIAlertController(title: "Opps!", message: "Sorry, we could not find your lover.", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.tabBarController?.selectedIndex = 2
            }))
                   
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            loverLocationViewer.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUpdateLocation()
    }
    
    func settupNavigation() {

        navigationController?.navigationBar.backgroundColor = .white
        
        gpsButton = UIButton(type: .custom)
        gpsButton.setImage(UIImage(named: "gps"), for: [])
        let gpsTabBarItem = UIBarButtonItem(customView: gpsButton)
        gpsTabBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        gpsTabBarItem.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        gpsTabBarItem.customView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
//        phoneButton = UIButton(type: .custom)
//        phoneButton.setImage(UIImage(named: "phone"), for: [])
//        let phoneTabBarButton = UIBarButtonItem(customView: phoneButton)
        
        navigationItem.rightBarButtonItems = [gpsTabBarItem]
        
        backButton = UIButton(type: .custom)
        backButton.tintColor = Colors.kPink
        let backButtonImage = UIImage.awesomeIcon(name: .arrowLeft, textColor: Colors.kPink)
        backButton.setImage(backButtonImage, for: [])

        guard let friendConfig = try? viewModel.coupleModel.friendConfig.value() else { return }
        loverAvatar = Avatar(url: friendConfig.avatar)
        let avatarBarItem = UIBarButtonItem(customView: loverAvatar)
        
        loverNameLabel = UILabel()
        loverNameLabel.textColor = UIColor(rgb: 0xFA7268)
        let nameLabelTabBarItem = UIBarButtonItem(customView: loverNameLabel)
        loverNameLabel.text = friendConfig.name
        
        navigationItem.leftBarButtonItems = [avatarBarItem, nameLabelTabBarItem]
    }
    
    func settupViews() {
        mapView = MKMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        
        loverLocationViewer = LoverLocationViewer(location: viewModel.loverLocation)
        view.addSubview(loverLocationViewer)
        loverLocationViewer.delegate = self
    }
    
    func makeConstrainsts() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loverLocationViewer.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(175)
        }
        
        if viewModel.coupleModel.friendId != "local" {
            view.bringSubviewToFront(loverLocationViewer)
        } else {
            loverLocationViewer.isHidden = true
        }
    }
    
    func setupActions() {
        gpsButton.addTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
        backButton.addTarget(self, action: #selector(onBackButtonPress), for: [.touchUpInside])
//        phoneButton.addTarget(self, action: #selector(onPhoneButtonPress), for: [.touchUpInside])
    }
    
    func startUpdateLocation() {
        if LocationServices.shared.isAuthorization {
            LocationServices.shared.startUpdateLocation()
            return
        }
        openSettingForLocation()
    }

    @objc func onPhoneButtonPress() {
        guard let phoneNumber = viewModel.coupleModel.friendInfo?.phoneNumber else {
            return
        }
        callNumber(phoneNumber: phoneNumber)
    }
    
    @objc func onBackButtonPress() {
        self.popBack()
    }
    
    func subscribeViewModel() {
        viewModel
            .currentLocation
            .subscribe(onNext: {[unowned self] (location) in
                guard let location = location else { return }
                
                if self.currentAnotation != nil {
                    self.currentAnotation.coordinate = location.coordinate
                    return
                }
                
                self.currentAnotation = MapViewAnotaion(title: "Your location",
                                                        locationName: "Current location",
                                                        discipline: "Current location",
                                                        coordinate: location.coordinate)
                self.mapView.addAnnotation(self.currentAnotation)
            }).disposed(by: disposeBag)
        
        viewModel
            .loverLocation
            .subscribe(onNext: {[unowned self] (location) in
                guard let location = location, let friendConfig = try? self.viewModel.coupleModel.friendConfig.value() else { return  }
                
                if self.loverAnotation != nil {
                    self.loverAnotation.coordinate = location.coordinate
                    return
                }
                
                let regionRadius: CLLocationDistance = 1000
                let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: regionRadius,
                                                          longitudinalMeters: regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.loverAnotation = MapViewAnotaion(title: "Lover location",
                                                      locationName: friendConfig.name,
                                                      discipline: friendConfig.name,
                                                      coordinate: location.coordinate)
                self.mapView.addAnnotation(self.loverAnotation)
            }).disposed(by: disposeBag)
    }
    
    func caculateRoute(completion: (() -> Void)? ) {
        if currentAnotation == nil || loverAnotation == nil {
            return
        }
        let request: MKDirections.Request = MKDirections.Request()
        
        let sourcePlaceMark: MKPlacemark = MKPlacemark(coordinate: currentAnotation.coordinate)
        let loverPlaceMark: MKPlacemark = MKPlacemark(coordinate: loverAnotation.coordinate)
        
        request.source = MKMapItem(placemark: sourcePlaceMark)
        request.destination = MKMapItem(placemark: loverPlaceMark)
        
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculate { [weak self] (response, error) in
            if error != nil {
                showMessage(title: "Opps!", message: "Sorry! We can not find the direction between you two, Please try again later!", theme: .warning)
                completion?()
                return
            }
            
            guard let directionResponse = response, let route = directionResponse.routes.first else {
                completion?()
                return
            }
            
            if let oldRoute = self?.directionRoute {
                self?.mapView.removeOverlay(oldRoute.polyline)
            }
            
            self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let region = MKCoordinateRegion(route.polyline.boundingMapRect)
            self?.directionRoute = route
            self?.mapView.setRegion(region, animated: true)
            completion?()
        }
    }
    
    @objc func onGpsButtonPress() {
        guard let location = try? viewModel.currentLocation.value() else { return }
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    deinit {
        gpsButton.removeTarget(self, action: #selector(onGpsButtonPress), for: [.touchUpInside])
        backButton?.removeTarget(self, action: #selector(onBackButtonPress), for: [.touchUpInside])
//        phoneButton?.removeTarget(self, action: #selector(onPhoneButtonPress), for: [.touchUpInside])
    }
}

extension LocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            let isLoverAnotation = annotation.title == loverAnotation.title
            guard let friendConfig = try? viewModel.coupleModel.friendConfig.value(),
                let userConfig = try? viewModel.coupleModel.userConfig.value() else { return annotationView }
            let avatar = isLoverAnotation ? friendConfig.avatar : userConfig.avatar
            let resource = URL(string: avatar) ?? Avatar.kDefaultAvatar
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 36, height: 36)) |> RoundCornerImageProcessor(cornerRadius: 18)
            KingfisherManager.shared.retrieveImage(with: resource!, options: [.processor(resizingProcessor)]) { (res) in
                guard let image = try? res.get() else { return }
                annotationView.image = image.image
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = Colors.kPink
        renderer.lineWidth = 4
        
        return renderer
    }
}

extension LocationViewController: LoverLocationViewerDelegate {
    func loverLocationViewer(requestShowDirection loverLocationViewer: LoverLocationViewer) {
        AppLoadingIndicator.shared.show()
        caculateRoute {
            AppLoadingIndicator.shared.hide()
        }
    }
}

func openSettingForLocation() {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: "Oops!", message: "We don't have permission to access your location! Go to Setting and then allow us to access your location?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.present(alertController, animated: true, completion: nil)
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
