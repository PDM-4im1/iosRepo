//
//  MapView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 30/11/2023.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var showCurrentLocation: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 36.8065, longitude: 10.1815, zoom: 8)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = true
        mapView.animate(toZoom: 8)
         mapView.isMyLocationEnabled = true
        context.coordinator.showUserLocation(on: mapView)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if showCurrentLocation {
            context.coordinator.showUserLocation(on: mapView)
        }
    }

    class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func showUserLocation(on mapView: GMSMapView) {
            guard let coordinate = mapView.myLocation?.coordinate else { return }
            
            // Clear existing overlays
            mapView.clear()
            
            // Add marker for user location
            let marker = GMSMarker(position: coordinate)
            marker.icon = UIImage(named: "ic_current_location")
            marker.map = mapView
            
            // Move camera to user location
            mapView.animate(to: GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0))
        }
    }
    
}
