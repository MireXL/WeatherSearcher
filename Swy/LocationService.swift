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
    var locationManagerCallback : ((String?) -> ())?
    static let sharedInstance:LocationService = {
        let instance = LocationService()
        return instance
    }()
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
    }
    
    @objc func startUpdatingLocation(completion : @escaping (String?) -> ()) {
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

    @objc func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    @objc func getLocation (completion : @escaping (String) -> ()) {
        LocationService.sharedInstance.startUpdatingLocation(completion: {(currentLocation) in
            if let location = (currentLocation){
                //print("lol\(location)")
                completion(location)
            }

        })
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation = "lat=\(locValue.latitude)&lon=\(locValue.longitude)"
        self.locationManager?.stopUpdatingLocation()
        locationManagerCallback?(currentLocation)
        print(currentLocation)
    }
    
}
