//
//  AppDelagte.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 30/11/2023.
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")
        GMSPlacesClient.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")

        requestLocationPermission()

        return true
    }

    func requestLocationPermission() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
}
