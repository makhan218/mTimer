//
//  LocationServices.swift
//  MCounter
//
//  Created by apple on 5/10/19.
//  Copyright © 2019 WeOverOne. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationServices()
    let locationManager = CLLocationManager()
    var location:CLLocationCoordinate2D?
    var locationAllowed = false
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationServces()
    }
    
    func checkLocationAuthorization() -> CLAuthorizationStatus {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationAllowed = true
            locationManager.startUpdatingLocation()
            return .authorizedWhenInUse
        case .denied:
            // access denied
            AppStateStore.shared.autoDayNightOn = false
            locationAllowed = false
            return .denied
        case .notDetermined:
            locationAllowed = false
            locationManager.requestWhenInUseAuthorization()
            return .notDetermined
        case .restricted:
            locationAllowed = false
            // show allert
            return .restricted
        case .authorizedAlways:
            return.authorizedAlways
        }
    }
    
    func checkLocationServces() {
        
        if CLLocationManager.locationServicesEnabled() {
//            setupLocationManager()
            _ = checkLocationAuthorization()
            location = locationManager.location?.coordinate
//            locationAllowed = true
        }
        else {
            // Show user to show location services aren't on
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locationManager.location?.coordinate
        locationAllowed = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        location = locationManager.location?.coordinate
//        locationAllowed = true
    }
    
    func checkAndManageAccess() {
        if CLLocationManager.locationServicesEnabled() {
            //            setupLocationManager()
            if checkLocationAuthorization() == .denied {
                showSimpleAlert()
            }
            else {
                location = locationManager.location?.coordinate
                locationAllowed = true
            }
        }
        else {
                // Show user to show location services aren't on
        }
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Location Access Required", message: "To activate auto day/night mode we need to get your location",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Go to Settings",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
                                            UIApplication.shared.openURL(url)
                                        }
        }))
        getTopViewController()?.present(alert, animated: true, completion: nil)
    }
    
}

extension LocationServices {
    
    func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
//                return topController
            }
            return topController
            // topController should now be your topmost view controller
        }
       return nil
    }
}
