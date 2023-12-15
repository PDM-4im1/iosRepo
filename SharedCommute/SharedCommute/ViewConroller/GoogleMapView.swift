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
    @Binding var isButtonTapped : Bool
    
    @Binding var showAlert: Bool
    @Binding var alertText: String
    @State private var estimatedDuration: String = ""
    @State private var isLoading: Bool = false

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<GoogleMapsView>) -> GMSMapView {
        locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.89771, longitude: 10.18962, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        
        // Add a green marker at the specified coordinates
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 36.89771, longitude: 10.18962)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
        
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: UIViewRepresentableContext<GoogleMapsView>) {
        guard isButtonTapped else {
            return
        }

        _ = CLGeocoder()

        self.geocodeAddress(address: self.source) { sourceLocation in
            self.geocodeAddress(address: self.destination) { destinationLocation in
                guard let sourceLocation = sourceLocation, let destinationLocation = destinationLocation else {
                    return
                }

                // Clear the map before adding new markers and routes
                mapView.clear()

                let sourceMarker = GMSMarker()
                sourceMarker.position = sourceLocation
                sourceMarker.map = mapView

                let destinationMarker = GMSMarker()
                destinationMarker.position = destinationLocation
                destinationMarker.map = mapView

                self.fetchRoutes(from: sourceLocation, to: destinationLocation, mapView: mapView) { polylines, duration in
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

                            // Ensure these updates are performed on the main thread
                            DispatchQueue.main.async {
                                self.estimatedDuration = "Estimated Duration: \(duration)"
                                self.isLoading = false // Stop loading indicator
                                self.isButtonTapped = false

                                // Show the alert with the estimated duration
                                self.alertText = "Estimated Duration: \(duration)"
                                self.showAlert = true
                            }
                        }
                    }
                }
            }
    }


    
    
    
    
    private func fetchRoutes(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, mapView: GMSMapView, completion: @escaping ([GMSPolyline], String) -> Void) {
        let origin = "\(source.latitude),\(source.longitude)"
        let destination = "\(destination.latitude),\(destination.longitude)"
        
        let apiKey = getGoogleMapsAPIKey()!
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
                    var durationText = ""

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

                        if let legs = route["legs"] as? [[String: Any]],
                           let duration = legs.first?["duration"] as? [String: Any],
                           let text = duration["text"] as? String {
                            durationText = text
                            print(durationText)
                        }
                    }

                    DispatchQueue.main.async {
                        completion(polylines, durationText)
                    }
                }
            } catch {
                print("Error parsing routing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        guard let apiKey = getGoogleMapsAPIKey() else {
            print("API key is missing")
            completion(nil)
            return
        }

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


    // Function to retrieve the Google Maps API key from a secure location
  

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
    }
}
func getGoogleMapsAPIKey() -> String? {
    // Implement the logic to securely retrieve your API key
    return "AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74"
}
