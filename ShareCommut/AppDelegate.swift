//
//  AppDelegate.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 30/11/2023.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           GMSServices.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")

           return true
       }
  

    // Other app delegate methods

}
