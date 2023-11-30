//
//  MapView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 30/11/2023.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable  {
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update the map view if needed
    }
}
