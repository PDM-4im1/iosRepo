//
//  MapView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 30/11/2023.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var showhospitals: Bool
    @Binding var showPolice: Bool
    @Binding var showPharmacy: Bool
    @Binding var showDoctor: Bool
    @Binding var Traceroute: Bool
    @Binding var source: String
    @Binding var destination: String
    @Binding var routes: [GMSPolyline]
    
    
    var controller = CarMapController()
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        coordinator.viewController = CarMapController()
        return coordinator
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
        //context.coordinator.showUserLocation(on: mapView)
        if let controller = context.coordinator.viewController {
            print("MapView - setMapView called on CarMapController: \(controller)")
        } else {
            print("MapView - CarMapController is nil")
        }
        return mapView
    }
    struct NearbySearchResult: Codable {
        struct Geometry: Codable {
            struct Location: Codable {
                let lat: Double
                let lng: Double
            }
            
            let location: Location
        }
        
        struct Place: Codable {
            let name: String
            let geometry: Geometry
        }
        
        let results: [Place]
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
        guard showhospitals || showPolice || showPharmacy || showDoctor || Traceroute else {
            return
        }
        
        var placeType = ""
        
        if showhospitals {
            placeType = "hospital"
        } else if showPolice {
            placeType = "police"
        } else if showPharmacy {
            placeType = "pharmacy"
        } else if showDoctor {
            placeType = "doctor"
        }
        if showhospitals || showPolice || showPharmacy || showDoctor {
            // Execute this block if any of the show* flags is true
            context.coordinator.fetchNearbyPlaces(for: mapView, stringvalue: placeType)
        } else if Traceroute {
            // Execute this block if Traceroute is true
            _ = CLGeocoder()
            
            self.geocodeAddress(address: self.source) { sourceLocation in
                self.geocodeAddress(address: self.destination) { destinationLocation in
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
                    
                    self.fetchRoutes(from: sourceLocation, to: destinationLocation, mapView: mapView) { polylines in
                        DispatchQueue.main.async {
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
                    }
                }
            }
        

                
                DispatchQueue.main.async {
                    self.showhospitals = false
                    self.showPolice = false
                    self.showPharmacy = false
                    self.showDoctor = false
                    self.Traceroute = false
                    
                }
            }
        }
    
            
            
            
            private func fetchRoutes(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, mapView: GMSMapView, completion: @escaping ([GMSPolyline]) -> Void) {
                mapView.clear()
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
            func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
                
                let apiKey = "AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74"
                
                let addressEncoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressEncoded)&key=\(apiKey)"
                
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    completion(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Geocoding error: \(error.localizedDescription)")
                        // Ensure completion is called on the main thread
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    guard let data = data else {
                        print("Geocoding data is nil")
                        // Ensure completion is called on the main thread
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let results = json["results"] as? [[String: Any]],
                           let geometry = results.first?["geometry"] as? [String: Any],
                           let location = geometry["location"] as? [String: Any],
                           let lat = location["lat"] as? Double,
                           let lng = location["lng"] as? Double {
                            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            // Ensure completion is called on the main thread
                            DispatchQueue.main.async {
                                completion(coordinates)
                            }
                        } else {
                            print("Error parsing geocoding response")
                            // Ensure completion is called on the main thread
                            DispatchQueue.main.async {
                                completion(nil)
                            }
                        }
                    } catch {
                        print("Error parsing geocoding JSON: \(error.localizedDescription)")
                        // Ensure completion is called on the main thread
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }.resume()
            }
            
            class Coordinator: NSObject, GMSMapViewDelegate, CLLocationManagerDelegate {
                var parent: MapView
                var viewController: CarMapController?
                
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
                    
                    // Show hospitals
                    
                    
                    
                    
                    
                }
                
                func fetchNearbyPlaces(for mapView: GMSMapView, stringvalue: String) {
                    guard let userLocation = mapView.myLocation?.coordinate else {
                        print("Error fetching nearby places: User's location is nil")
                        return
                    }
                    
                    let radius: Double = 6000
                    let placesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.latitude),\(userLocation.longitude)&radius=\(radius)&types=\(stringvalue)&key=AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74"
                    
                    if let url = URL(string: placesURL) {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("Error fetching nearby places: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let data = data else {
                                print("Error fetching nearby places: No data received")
                                return
                            }
                            
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(NearbySearchResult.self, from: data)
                                
                                DispatchQueue.main.async {
                                    // Clear existing markers and circles on the map
                                    mapView.clear()
                                    
                                    // Add a blue circle around the user's location
                                    let circle = GMSCircle(position: userLocation, radius: radius)
                                    circle.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
                                    circle.map = mapView
                                    
                                    // Create a specific camera position
                                    let cameraPosition = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 11.6)
                                    
                                    // Set the camera position
                                    mapView.camera = cameraPosition
                                    
                                    for place in result.results {
                                        let marker = GMSMarker()
                                        marker.position = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
                                        marker.title = place.name
                                        marker.icon = GMSMarker.markerImage(with: .blue)
                                        marker.map = mapView
                                        
                                        // Add a tap gesture recognizer to each marker
                                        marker.isTappable = true
                                        marker.userData = place // Store place data for later use
                                        marker.map = mapView
                                    }
                                }
                            } catch {
                                print("Error decoding JSON: \(error.localizedDescription)")
                            }
                        }.resume()
                    }
                }
                
                
                
                func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
                    var source:CLLocationCoordinate2D;
                    // Handle marker tap here
                    if let place = marker.userData as? NearbySearchResult.Place {
                        // You can access place details here and use them for routing
                        mapView.clear()
                        let destinationMarker = GMSMarker()
                        destinationMarker.position = marker.position
                        destinationMarker.map = mapView
                        print("Marker tapped: \(place.name)")
                        if parent.source.isEmpty {
                            parent.source = "\(mapView.myLocation!.coordinate)"
                            source = mapView.myLocation!.coordinate
                            parent.fetchRoutes(from: source, to: marker.position, mapView: mapView) { polylines in
                                // Handle polylines, e.g., display on the map
                            }
                        } else {
                            parent.geocodeAddress(address: parent.source) { coordinates in
                                guard let coordinates = coordinates else {
                                    print("Error geocoding address")
                                    return
                                }
                                
                                
                                self.parent.fetchRoutes(from: coordinates, to: marker.position, mapView: mapView) { polylines in
                                    // Handle polylines, e.g., display on the map
                                }
                            }
                        }
                        parent.destination = "\(marker.position)"
                        // Access the parent MapView and call fetchRoutes
                        
                    }
                    return true
                }
                
            }
            
        }
        
        
        
    

