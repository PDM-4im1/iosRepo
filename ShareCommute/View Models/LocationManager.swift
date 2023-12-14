//
//  LocationManager.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 6/12/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }


    // Check if location services are enabled
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    // Check if the app has location authorization
    func hasLocationAuthorization() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }

    // Request location authorization
    func requestLocationAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    // Start updating location
    func startUpdatingLocation() {
        if isLocationServicesEnabled() && !hasLocationAuthorization() {
            requestLocationAuthorization()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }

    // CLLocationManagerDelegate method - called when the location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            userLocation = location
        }
    }
}


