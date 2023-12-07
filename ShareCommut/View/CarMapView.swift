//
//  CarMapView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI
import GooglePlaces
import GoogleMaps
import MapKit


struct CarMapView: View {
    @State private var showCurrentLocation = false
    @State private var source: String = ""
    @State private var destination: String = ""
    @State private var showhospitals: Bool = false
    @State private var showPharmacy: Bool = false
    @State private var showPolice: Bool = false
    @State private var showDoctor: Bool = false
    @State private var Traceroute: Bool = false

    @StateObject private var controller = CarMapController()
    @StateObject private var coordinator = Coordinator()
    /*func showHospitals() {
        guard let mapView = controller.getMap() else {
                    print("Error fetching nearby places: mapView is nil",controller.getMap())
                       return
                   }
                    print("showHospitals - mapView: \(mapView)")
                   // Call Google Places API to get nearby hospitals
                   let placesClient = GMSPlacesClient.shared()

                   // Replace with the appropriate coordinate based on your logic
                   guard let location = mapView.myLocation?.coordinate else {
                       print("Error fetching nearby places: User's location is nil")
                       return
                   }

                   let filter = GMSAutocompleteFilter()
                   filter.type = .establishment

                   placesClient.findAutocompletePredictions(
                       fromQuery: "hospital",  // You can use "hospital", "police", "pharmacy", etc.
                       filter: filter,
                       sessionToken: nil
                   ) { (results, error) in
                       if let error = error {
                           print("Error fetching nearby places: \(error.localizedDescription)")
                           return
                       }

                       // Clear existing markers on the map
                       mapView.clear()

                       // Add markers for each place
                       for result in results ?? [] {
                           placesClient.fetchPlace(
                               fromPlaceID: result.placeID ,
                               placeFields: GMSPlaceField.all,
                               sessionToken: nil
                           ) { (place, error) in
                               if let error = error {
                                   print("Error fetching place details: \(error.localizedDescription)")
                                   return
                               }

                               if let place = place {
                                   let marker = GMSMarker()
                                   marker.position = place.coordinate
                                   marker.title = place.name
                                   marker.map = mapView
                               }
                           }
                       }
                   } }*/
    private func showAutocomplete(for field: String) {
        coordinator.selectedField = field
        coordinator.parent = self
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = coordinator
        UIApplication.shared.windows.first?.rootViewController?.present(autocompleteController, animated: true, completion: nil)
    }
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack(spacing: 10){
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        TextField("Find location here", text: $source).onTapGesture {
                            showAutocomplete(for: "source")
                        }
                        
                    }
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(.gray)
                    }
                    .padding(.vertical,10)
                    HStack{
                        Button{
                            
                        }label: {
                            Label{
                                Text("Use Current Location")
                                    .font(.callout)
                                
                            }icon: {
                                Image(systemName: "location.north.circle.fill")
                            }
                            .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        Text(destination.isEmpty ? "Where to go?" : destination)
                            .onTapGesture {
                                Traceroute = true
                                showAutocomplete(for: "destination")
                            }
                        
                        
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.clear)
                    }
                    .padding(3)
                    
                    HStack {
                        ImageButton(imageName: "ic_hospital", title: "Hospitals").onTapGesture {
                            showhospitals = true
                            //showHospitals()
                                                }
                        ImageButton(imageName: "ic_police", title: "Police").onTapGesture {
                            showPolice = true
                            //showHospitals()
                                                }
                        ImageButton(imageName: "ic_pharmacy", title: "Pharmacy").onTapGesture {
                            showPharmacy = true
                            //showHospitals()
                                                }
                        ImageButton(imageName: "ic_doctor", title: "Doctor").onTapGesture {
                            showDoctor = true
                            //showHospitals()
                                                }
                    }
                    .padding(3)
                }
                .cornerRadius(20)
                
                // MapView
                MapView(showhospitals:$showhospitals,showPolice: $showPolice,showPharmacy: $showPharmacy ,showDoctor: $showDoctor ,Traceroute: $Traceroute)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    Text("Duration")
                        .foregroundColor(.red)
                        .padding()
                        .hidden()
                    
                    Text("Price")
                        .hidden()
                    
                    Spacer()
                    
                    NavigationLink(destination: CovoiturageView()) {
                        Text("Ride")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(5)
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        
    }
    // Coordinator to handle Google Places autocomplete callbacks
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate, ObservableObject {
        var selectedField: String = ""
        var parent: CarMapView?
        
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
    


    


struct ImageButton: View {
    let imageName: String
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 70, height: 80)
    }
}

struct CarMapView_Previews: PreviewProvider {
    static var previews: some View {
        CarMapView().environmentObject(CarMapController())
    }
}
