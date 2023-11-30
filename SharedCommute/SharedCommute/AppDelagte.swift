//
//  AppDelagte.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 30/11/2023.
import UIKit
import GoogleMaps

class AppDelegate: NSObject , UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")
        return true
    }


  
}
