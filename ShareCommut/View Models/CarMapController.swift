//
//  CarMapController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces

class CarMapController: UIViewController,ObservableObject{
    private var mapViewHasBeenSet = false
    @Published var mapView: GMSMapView? 
    func setMapView(_ mapVieww: GMSMapView?) {
        mapView = mapVieww
        print("mapppp",mapView)
        
    }
    func getMap() -> GMSMapView?{
        print("geeetmapppp",mapView)
        return mapView
    }
     
    
}


