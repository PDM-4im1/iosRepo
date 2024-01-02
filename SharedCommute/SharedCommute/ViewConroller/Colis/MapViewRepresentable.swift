//
//  MapViewRepresentable.swift
//  project
//
//  Created by Apple Esprit on 27/11/2023.
//

import SwiftUI
import MapKit

struct MapViewRepresentable : UIViewRepresentable{
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled=false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
        
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
            switch mapState {
            case .noInput:
                context.coordinator.clearMapViewAndRecenterOnUserLocation()
            case .searchingForLocation:
                break
            case .locationSelected:
                if let coordinate = locationViewModel.selectedLocationCoordinate,
                   let userCoordinate = locationViewModel.userLocation {
                    context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                    context.coordinator.configurePolyline(
                        withDestinationCoordinate: coordinate,
                        fromUserCoordinate: userCoordinate
                    )
                }
            }
        }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D, completion:
                             @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let direction = MKDirections(request: request)
        
        direction.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else {
                print("DEBUG: No route available")
                return
            }
            completion(route)
        }
    }
}

extension MapViewRepresentable {
    class MapCoordinator : NSObject, MKMapViewDelegate {
        
        
        let parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->
        MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        func addAndSelectAnnotation(withCoordinate coordinate : CLLocationCoordinate2D){
         //   parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D,
                                       fromUserCoordinate userCoordinate: CLLocationCoordinate2D) {
                    // Create a route from the user's location to the selected destination
                    parent.getDestinationRoute(from: userCoordinate, to: coordinate) { route in
                        // Add the route as an overlay on the map
                        self.parent.mapView.addOverlay(route.polyline)
                        
                        // Set the visible region to fit the route and user's location
                        let rect = self.parent.mapView.mapRectThatFits(
                            route.polyline.boundingMapRect,
                            edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32)
                        )
                        self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    }
                }
        
        func clearMapViewAndRecenterOnUserLocation(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
