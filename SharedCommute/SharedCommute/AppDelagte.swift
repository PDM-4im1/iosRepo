//
//  AppDelagte.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 30/11/2023.
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Firebase
import UserNotifications
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")
        GMSPlacesClient.provideAPIKey("AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")

        requestLocationPermission()
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {success, _ in
            guard success else {
                return
            }
            print("Success is APNS registry")
        }
       
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else{
                return
            }
            print("Token: \(token)")
            
        }
         guard let token = fcmToken else { return }
        print("FCM Token: \(token)")
        }

        func requestLocationPermission() {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
        }
 
}
