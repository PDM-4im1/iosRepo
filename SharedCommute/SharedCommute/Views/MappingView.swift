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
     @State private var Confirmdisabled: Bool = false
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
            GeometryReader { geometry in

            VStack(spacing: 16) {
                ZStack(alignment: .trailing) {
                    TextField("Source", text: $source)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .id("sourceTextField")
                        .onTapGesture {
                            withAnimation {
                                showAutocomplete(for: "source")
                            }
                        }

                    Button(action: {
                        withAnimation {
                            getUserLocation()
                        }
                    }) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))

                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))

                                TextField("Destination", text: $destination)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .id("destinationTextField")
                                    .onTapGesture {
                                        withAnimation {
                                            showAutocomplete(for: "destination")
                                        }
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))

                                Button(action: {
                                    withAnimation {
                                        Confirmdisabled = false ? (source == "" || destination == "") : true;

                                        isButtonTapped = true
                                    }
                                }) {
                                    Text("Confirm Direction")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                        .frame(width: geometry.size.width * 0.4)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                            }
                                        .padding(.horizontal)

                GoogleMapsView(source: $source, destination: $destination, routes: $routes, isButtonTapped: $isButtonTapped, showAlert: $showAlert, alertText: $alertText)
                    .frame(height: 220) // Adjust the height according to your needs
                    .edgesIgnoringSafeArea(.all)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 4))
                          Button(action: {
                              withAnimation {
                                  showPicker = true
                              }
                          }) {
                              NavigationLink(destination:( TimePickerView(selectedHour: $selectedHourMapping, selectedMinute: $selectedMinuteMapping, source: $source, destination: $destination, idcovoiturage: $idcovoiturage)), isActive: $showPicker ) {
                                  Text("Confirm Your Trip")
                                      .font(.caption)
                                      .foregroundColor(.white)
                                      .padding(.vertical, 12)
                                      .frame(width: geometry.size.width * 0.4)
                                      .background(
                                          !Confirmdisabled
                                              ? Color.blue.opacity(0.0)
                                              : Color.blue)
                                      .cornerRadius(8)}}
                          .padding()
                          .disabled(!Confirmdisabled)
                      }
                      .padding()
                      .background(Color.gray.opacity(0.1))
                      .navigationBarItems(
                          leading: NavigationLink(
                              destination:(CovoiturageListView() ).navigationBarBackButtonHidden(true)
                          ) {
                              Image(systemName: "chevron.left")
                                  .font(.system(size: 12)) // Adjust the font size here
                                  .foregroundColor(.blue)
                              Text("Back")
                              
                          },
                          trailing: EmptyView()
                      )
                      .onAppear {
                          source = internalsource
                          destination = internaldestination
                          selectedHourMapping = selectedHoursMapping
                          selectedMinuteMapping = selectedMinutesMapping
                          idcovoiturage = initialidcovoiturage
                      }
                  }
                  .navigationViewStyle(StackNavigationViewStyle())
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
