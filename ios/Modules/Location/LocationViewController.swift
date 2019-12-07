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
    
    var viewModel: LocationViewModel { get set }
    
    func settupViews()
    
    func makeConstrainsts()
}

class LocationViewController: UIViewController, LocationViewControllerType {
    var mapView: MKMapView!
    
    var backButton: UIButton!
    
    var phoneButton: UIButton!
    
    var loverNameLabel: UILabel!
    
    var loverAvatar: Avatar!
    
    var currentAnotation: MapViewAnotaion!
    
    var loverAnotation: MapViewAnotaion!
    
    var loverLocationViewer: LoverLocationViewer!
    
    var directionRoute: MKRoute?
    
    var viewModel: LocationViewModel = LocationViewModel(loverPath: "0349055710")
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupNavigation()
        settupViews()
        makeConstrainsts()
        subscribeViewModel()
        setupActions()
    }
    
    func settupNavigation() {
        navigationController?.navigationBar.backgroundColor = .white

        phoneButton = UIButton(type: .custom)
        phoneButton.setImage(UIImage(named: "phone"), for: [])
        let phoneTabBarButton = UIBarButtonItem(customView: phoneButton)
        
        navigationItem.rightBarButtonItems = [phoneTabBarButton]
        
        backButton = UIButton(type: .detailDisclosure)
        backButton.tintColor = Colors.kPink
        let backTabBarButton = UIBarButtonItem(customView: backButton)
        
        loverAvatar = Avatar(url: "https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg")
        let avatarBarItem = UIBarButtonItem(customView: loverAvatar)
        
        loverNameLabel = UILabel()
        loverNameLabel.textColor = UIColor(rgb: 0xFA7268)
        let nameLabelTabBarItem = UIBarButtonItem(customView: loverNameLabel)
        loverNameLabel.text = "Lover"
        
        navigationItem.leftBarButtonItems = [backTabBarButton, avatarBarItem, nameLabelTabBarItem]
    }
    
    func settupViews() {
        mapView = MKMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        
        loverLocationViewer = LoverLocationViewer()
        view.addSubview(loverLocationViewer)
       
    }
    
    func makeConstrainsts() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loverLocationViewer.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(200)
        }
        view.bringSubviewToFront(loverLocationViewer)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(onBackButtonPress), for: [.touchUpInside])
    }
    
    @objc func onBackButtonPress() {
        self.popBack()
    }
    
    func subscribeViewModel() {
        viewModel
            .currentLocation
            .subscribe(onNext: {[unowned self] (location) in
                guard let location = location else {
                    return
                }
                
                if self.currentAnotation != nil {
                    self.currentAnotation.coordinate = location.coordinate
                    self.caculateRoute()
                    return
                }
                
                let regionRadius: CLLocationDistance = 1000
                let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.currentAnotation = MapViewAnotaion(title: "Current",
                                                        locationName: "Current",
                                                        discipline: "Current",
                                                        coordinate: location.coordinate)
                self.mapView.addAnnotation(self.currentAnotation)
                self.caculateRoute()
            }).disposed(by: disposeBag)
        
        viewModel
            .loverLocation
            .subscribe(onNext: {[unowned self] (location) in
                guard let location = location else {
                    return
                }
                
                if self.loverAnotation != nil {
                    self.loverAnotation.coordinate = location.coordinate
                    self.caculateRoute()
                    return
                }
                
                let regionRadius: CLLocationDistance = 1000
                let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                self.loverAnotation = MapViewAnotaion(title: "loverAnotation",
                                                      locationName: "loverAnotation",
                                                      discipline: "loverAnotation",
                                                      coordinate: location.coordinate)
                self.mapView.addAnnotation(self.loverAnotation)
                self.caculateRoute()
            }).disposed(by: disposeBag)
    }
    
    func caculateRoute() {
        if currentAnotation == nil ||  loverAnotation == nil {
            return
        }
        let request: MKDirections.Request = MKDirections.Request()
        
        let sourcePlaceMark: MKPlacemark = MKPlacemark(coordinate: currentAnotation.coordinate)
        let loverPlaceMark: MKPlacemark = MKPlacemark(coordinate: loverAnotation.coordinate)
        
        request.source = MKMapItem(placemark: sourcePlaceMark)
        request.destination = MKMapItem(placemark: loverPlaceMark)
        
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculate { [unowned self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let directionResponse = response, let route = directionResponse.routes.first else {
                return
            }
            if let oldRoute = self.directionRoute {
                self.mapView.removeOverlay(oldRoute.polyline)
            }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let region = MKCoordinateRegion(route.polyline.boundingMapRect)
            self.directionRoute = route
            self.mapView.setRegion(region, animated: true)
        }
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
            let resource = URL(string: "https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg")
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 36, height: 36)) >> RoundCornerImageProcessor(cornerRadius: 18)
            UIImageView().kf.setImage(with: resource, options: [.processor(resizingProcessor)]) { (image, _, _, _) in
                annotationView.image = image
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
