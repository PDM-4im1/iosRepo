//
//  MappingView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 28/11/2023.
//



import SwiftUI
import GoogleMaps
import GooglePlaces

struct MappingView: View {
    @State private var source: String = ""
    @State private var destination: String = ""
    @State private var routes: [GMSPolyline] = []
    @State private var isButtonTapped: Bool = false

    @StateObject private var locationManager = LocationManager()
    @StateObject private var coordinator = Coordinator()

    @State private var showingAutocomplete = false

    private func getUserLocation() {
        if let userLocation = locationManager.userLocation {
            let apiKey = "AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74"
            let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(userLocation.latitude),\(userLocation.longitude)&key=\(apiKey)"

            if let url = URL(string: url) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let results = json["results"] as? [[String: Any]],
                       let address = results.first?["formatted_address"] as? String {
                        // Update the source with the real location name
                        DispatchQueue.main.async {
                            self.source = address
                        }
                    }
                }
                task.resume()
            }
        }
    }

    private func showAutocomplete(for field: String) {
        coordinator.selectedField = field
        coordinator.parent = self
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = coordinator
        UIApplication.shared.windows.first?.rootViewController?.present(autocompleteController, animated: true, completion: nil)
    }

    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .trailing) {
                TextField("Source", text: $source)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .id("sourceTextField")
                    .onTapGesture {
                        showAutocomplete(for: "source")
                    }

                Button(action: {
                    getUserLocation()
                }) {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
            }
            Spacer()

            TextField("Destination", text: $destination)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .id("destinationTextField")
                .onTapGesture {
                    showAutocomplete(for: "destination")
                }

            Spacer()

            Button(action: {
                isButtonTapped = true
            }) {
                Text("Confirm Direction")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            GoogleMapsView(source: $source, destination: $destination, routes: $routes, isButtonTapped: $isButtonTapped)
                .edgesIgnoringSafeArea(.all)
                .padding()
        }
    }

    // Coordinator to handle Google Places autocomplete callbacks
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate, ObservableObject {
        var selectedField: String = ""
        var parent: MappingView?

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            guard let parent = parent else { return }

            if selectedField == "source" {
                parent.source = place.formattedAddress ?? ""
            } else if selectedField == "destination" {
                parent.destination = place.formattedAddress ?? ""
            }

            viewController.dismiss(animated: true, completion: nil)
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}

struct MappingView_Previews: PreviewProvider {
    static var previews: some View {
        MappingView()
    }
}
