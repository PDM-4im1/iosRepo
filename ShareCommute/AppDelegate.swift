//
//  AppDelegate.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 30/11/2023.
//

import UIKit
import GoogleMaps
import SwiftUI
import GooglePlaces
import FirebaseCore

class AppDelegate: NSObject,  UIApplicationDelegate {
    var window: UIWindow?
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           GMSServices.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")
           GMSPlacesClient.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")
           let carMapView = CarMapView()
           
           
                FirebaseApp.configure()
                 // Create a UIHostingController with the CarMapView as the root view
                 let hostingController = UIHostingController(rootView: carMapView)
                 
                 // Create a UIWindow instance and set the rootViewController
                 window = UIWindow(frame: UIScreen.main.bounds)
                 window?.rootViewController = hostingController
                 
                 // Make the window visible
                 window?.makeKeyAndVisible()
                 
                 return true
       }
  

    // Other app delegate methods

}
