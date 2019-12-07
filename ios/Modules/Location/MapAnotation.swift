//
//  Marker.swift
//  Cupid
//
//  Created by Trần Tý on 12/5/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import MapKit

@objc class MapViewAnotaion: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  @objc dynamic var coordinate: CLLocationCoordinate2D
  
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
}
