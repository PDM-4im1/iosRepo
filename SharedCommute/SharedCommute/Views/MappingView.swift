//
//  MappingView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 28/11/2023.
//



import SwiftUI
import GoogleMaps



struct MappingView: View {
    @State private var source: String = ""
    @State private var destination: String = ""
    @State private var routes: [GMSPolyline] = []
    @State private var isButtonTapped: Bool = false

    @StateObject private var locationManager = LocationManager()
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


    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .trailing) {
                TextField("Source", text: $source)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .id("sourceTextField")

                Button(action: {
                    // Call the function to get user's location and update source
                    getUserLocation()
                }) {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                }
            }
            Spacer()
            Spacer()

            TextField("Destination", text: $destination)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .id("destinationTextField")

            Spacer()
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

    
}

struct MappingView_Previews: PreviewProvider {
    static var previews: some View {
        MappingView()
    }
}
