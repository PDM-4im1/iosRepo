//
//  GoogleMapView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 30/11/2023.
//
import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    private let zoom: Float = 15.0
    private let locationManager = CLLocationManager()
    
    @Binding var source: String
    @Binding var destination: String
    @Binding var routes: [GMSPolyline]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<GoogleMapsView>) -> GMSMapView {
        locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.89771, longitude: 10.18962, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: UIViewRepresentableContext<GoogleMapsView>) {
        let geocoder = CLGeocoder()
        
        // Delay between geocoding requests
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.geocodeAddress(geocoder, address: self.source) { sourceLocation in
                self.geocodeAddress(geocoder, address: self.destination) { destinationLocation in
                    guard let sourceLocation = sourceLocation, let destinationLocation = destinationLocation else {
                        return
                    }
                    mapView.clear()

                    let sourceMarker = GMSMarker()
                    sourceMarker.position = sourceLocation
                    sourceMarker.map = mapView
                    
                    let destinationMarker = GMSMarker()
                    destinationMarker.position = destinationLocation
                    destinationMarker.map = mapView
                    
                    if self.routes.isEmpty {
                        self.fetchRoutes(from: sourceLocation, to: destinationLocation, mapView: mapView) { polylines in
                            self.routes = polylines
                            
                            for polyline in polylines {
                                polyline.map = mapView
                            }
                            
                            var bounds = GMSCoordinateBounds()
                            bounds = bounds.includingCoordinate(sourceLocation)
                            bounds = bounds.includingCoordinate(destinationLocation)
                            
                            for polyline in polylines {
                                if let path = polyline.path {
                                    for index in 0 ..< path.count() {
                                        let coordinate = path.coordinate(at: index)
                                        bounds = bounds.includingCoordinate(coordinate)
                                    }
                                }
                            }
                            
                            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                            mapView.moveCamera(update)
                        }
                    } else {
                        var bounds = GMSCoordinateBounds()
                        bounds = bounds.includingCoordinate(sourceLocation)
                        bounds = bounds.includingCoordinate(destinationLocation)
                        
                        for polyline in self.routes {
                            if let path = polyline.path {
                                for index in 0 ..< path.count() {
                                    let coordinate = path.coordinate(at: index)
                                    bounds = bounds.includingCoordinate(coordinate)
                                }
                            }
                        }
                        
                        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                        mapView.moveCamera(update)
                    }
                }
            }
        }
    }
    func geocodeAddress(_ geocoder: CLGeocoder, address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
       geocoder.geocodeAddressString(address) { placemarks, error in
           if let error = error {
               print("Geocoding error: \(error.localizedDescription)")
               completion(nil)
               return
           }
           
           if let placemark = placemarks?.first {
               let coordinates = placemark.location?.coordinate
               completion(coordinates)
           } else {
               completion(nil)
           }
       }
   }
    
    
    
    
    private func fetchRoutes(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, mapView: GMSMapView, completion: @escaping ([GMSPolyline]) -> Void) {
        let origin = "\(source.latitude),\(source.longitude)"
        let destination = "\(destination.latitude),\(destination.longitude)"
        
        let apiKey = "AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let error = error {
                print("Routing error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Routing data is nil")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let routes = json?["routes"] as? [[String: Any]] {
                    var polylines: [GMSPolyline] = []
                    
                    for route in routes {
                        if let routeOverviewPolyline = route["overview_polyline"] as? [String: Any],
                           let points = routeOverviewPolyline["points"] as? String {
                            if let path = GMSPath(fromEncodedPath: points) {
                                DispatchQueue.main.async { // Dispatch to the main thread
                                    let polyline = GMSPolyline(path: path)
                                    polyline.strokeWidth = 5.0
                                    polyline.strokeColor = .blue
                                    polyline.map = mapView
                                    polylines.append(polyline)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async { // Dispatch completion to the main thread
                        completion(polylines)
                    }
                }
            } catch {
                print("Error parsing routing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
    }
}
