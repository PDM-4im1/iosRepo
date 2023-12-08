//
//  MappingView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 28/11/2023.
//



import SwiftUI
import GoogleMaps
import GooglePlaces

public struct MappingView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var internalsource: String
       @Binding var internaldestination: String
       @Binding var selectedHoursMapping: Int
       @Binding var selectedMinutesMapping: Int
    @State private var source: String = ""
       @State private var destination: String = ""
    @State private var selectedHourMapping: Int = 0
       @State private var selectedMinuteMapping: Int = 0
      
     @State private var routes: [GMSPolyline] = []

     @State private var isButtonTapped: Bool = false
     @State private var showAlert: Bool = false
     @State private var alertText: String = ""
     @StateObject private var locationManager = LocationManager()
     @StateObject private var coordinator = Coordinator()

     @State private var showPicker: Bool = false
    @Binding var initialidcovoiturage : String
    @State private var idcovoiturage: String = ""

  
 

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

    public var body: some View {
            NavigationView {
                VStack {
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

                    TextField("Destination", text: $destination)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .id("destinationTextField")
                        .onTapGesture {
                            showAutocomplete(for: "destination")
                        }

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

                    GoogleMapsView(source: $source, destination: $destination, routes: $routes, isButtonTapped: $isButtonTapped, showAlert: $showAlert, alertText: $alertText)
                        .edgesIgnoringSafeArea(.all)
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Route Information"), message: Text(alertText), dismissButton: .default(Text("OK")))
                        }

                    Spacer()

                    NavigationLink(destination: TimePickerView(selectedHour: $selectedHourMapping,selectedMinute: $selectedMinuteMapping,source: $source,destination: $destination, idcovoiturage: $idcovoiturage), isActive: $showPicker) {
                        EmptyView()
                    }
                    .hidden()

                    Button(action: {
                        showPicker = true
                    }) {
                        Text("Confirm Your Trip")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
                .navigationBarTitle("Creating a Trip", displayMode: .inline)
                .navigationBarItems(
                               leading: Button(action: {
                                   presentationMode.wrappedValue.dismiss()
                               }) {
                                   Text("Back")
                               },
                               trailing: EmptyView()
                           )
                       }.onAppear {
                source = internalsource
                destination = internaldestination
                selectedHourMapping = selectedHoursMapping
                selectedMinuteMapping = selectedMinutesMapping
                idcovoiturage = initialidcovoiturage
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
        MappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))
    }
}
