//
//  LocationService.swift
//  Swy
//
//  Created by Николай Великанец on 22.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService : NSObject,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var currentLocation = String()
    var locationManagerCallback : ((Double?, Double?) -> ())?
    static let sharedInstance:LocationService = {
        let instance = LocationService()
        return instance
    }()
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
    }    
    func startUpdatingLocation(completion : @escaping (Double?, Double?) -> ()) {
        print("Starting Location Updates")
        
        guard let locationManager = self.locationManager else {return}
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        self.locationManager?.startUpdatingLocation()
        locationManagerCallback = completion
    }
    
    @objc func getLocation (completion : @escaping (Double,Double) -> ()) {
        LocationService.sharedInstance.startUpdatingLocation(completion: {latitute,longitude  in
          //  if let location = (currentLocation){
                //print("lol\(location)")
        
            guard let lat = latitute,
                let lon = longitude else {return}
                completion(lat,lon)
           // }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //currentLocation = "\(locValue.latitude),\(locValue.longitude)"
        self.locationManager?.stopUpdatingLocation()
        locationManagerCallback?(locValue.latitude,locValue.longitude)
        print(locValue.latitude,locValue.longitude)
    }
    
}
