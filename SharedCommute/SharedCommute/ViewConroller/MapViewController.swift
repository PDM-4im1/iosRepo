//
//  MapViewController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a GMSCameraPosition with desired coordinates and zoom level
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 12.0)

        // Create a GMSMapView with the camera position
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)

        // Add the map view to your view hierarchy
        view.addSubview(mapView)
    }
    
}
