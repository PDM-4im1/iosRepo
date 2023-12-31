//
//  ClientListCovoiturages.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 14/12/2023.
//
import SwiftUI
import CoreLocation


struct ClientListCovoiturages: View {
    @State private var covoiturages: [Covoiturage] = []
    @State private var nearbyCovoiturages: [Covoiturage] = []
    @Binding var source: String
    @Binding var destination: String

    private func reverseFormattedDate(dateString: String) -> (hour: Int, minute: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = dateFormatter.date(from: dateString) else {
            print("Error parsing date string.")
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else {
            print("Error extracting components from date.")
            return nil
        }

        return (hour, minute)
    }
    

    var body: some View {
            VStack {
                List {
                    ForEach(covoiturages) { covoiturage in
                        if let reverseDate = reverseFormattedDate(dateString: covoiturage.dateCovoiturage ?? "") {
                            NavigationLink(
                                destination:DriverView(driverID:covoiturage.id_cond)
                                .navigationBarHidden(false)
                            ) {
                                
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.blue)
                                            .padding(.trailing, 8)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Departure: \(covoiturage.pointDepart)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("Destination: \(covoiturage.pointArrivee)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            Text("Date: \(covoiturage.dateCovoiturage!)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .animation(.easeInOut(duration: 0.3))
                                                         }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Carpooling")
                .background(Color.blue.opacity(0.1))
                .onAppear {
                    fetchCovoiturages()
                    
                   
                }

                Spacer()
            }
            .padding()
            .background(Color.white)
        }
 
    private func fetchNearbyCovoiturages(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        // Use Google Maps API to fetch nearby places based on source and destination coordinates

        // Example URL (replace with your API key and parameters)
        let nearbyPlacesURL = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(source.latitude),\(source.longitude)&radius=5000&type=carpooling&key=AIzaSyCmXUO6nmL7sbV1Z6UEysVERFQUtQj6i74")!

        URLSession.shared.dataTask(with: nearbyPlacesURL) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let nearbyPlacesData = try decoder.decode(GooglePlacesResponse.self, from: data)

                    // Extract the geocoded coordinates from the response
                    let geocodedCoordinates = nearbyPlacesData.results.compactMap { place in
                        let location = place.geometry?.location
                        return CLLocationCoordinate2D(latitude: location?.lat ?? 0, longitude: location?.lng ?? 0)
                    }

                    // Filter the covoiturages based on geocoded coordinates
                    let filteredCovoiturages = self.covoiturages.filter { covoiturage in
                        let destinationCoordinates = covoiturage.pointArrivee.components(separatedBy: ",")
                        if destinationCoordinates.count == 2,
                           let latitude = Double(destinationCoordinates[0]),
                           let longitude = Double(destinationCoordinates[1]) {
                            let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            return geocodedCoordinates.contains { coord in
                                coord.latitude == destinationCoordinate.latitude && coord.longitude == destinationCoordinate.longitude
                            }
                        }
                        return false
                    }

                    // Update the @State property to trigger view refresh
                    DispatchQueue.main.async {
                        self.nearbyCovoiturages = filteredCovoiturages
                    }
                } catch {
                    print("Error decoding nearby places JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching nearby places: \(error)")
            }
        }.resume()
    }

    private func geocodeCoordinate(url: String, completion: @escaping (String?) -> Void) {
        guard let geocodeURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: geocodeURL) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let geocodingResponse = try decoder.decode(GeocodingResponse.self, from: data)

                    if let firstResult = geocodingResponse.results.first {
                        let address = firstResult.formattedAddress
                        completion(address)
                    } else {
                        completion(nil)
                    }


                } catch {
                    print("Error decoding geocode JSON: \(error)")
                    completion(nil)
                }
            } else if let error = error {
                print("Error fetching geocode data: \(error)")
                completion(nil)
            }
        }.resume()
    }



    private func fetchCovoiturages() {
        // Example URL:
        let findAllCovoituragesURL = URL(string: "http://localhost:9090/covoiturage/findAllCovoituragesClient")!

        URLSession.shared.dataTask(with: findAllCovoituragesURL) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let covoituragesData = try decoder.decode([Covoiturage].self, from: data)

                    DispatchQueue.main.async {
                        // Update the @State property to trigger view refresh
                        self.covoiturages = covoituragesData

                        // Filter the data after it has been updated
                        if !source.isEmpty && !destination.isEmpty {
                            self.covoiturages = self.covoiturages.filter { covoiturage in
                                return covoiturage.pointDepart == source && covoiturage.pointArrivee == destination
                            }
                        }
                        self.getCoordinate(from: source) { sourceCoordinate in
                                            self.getCoordinate(from: destination) { destinationCoordinate in
                                                if let sourceCoordinate = sourceCoordinate, let destinationCoordinate = destinationCoordinate {
                                                    self.fetchNearbyCovoiturages(source: sourceCoordinate, destination: destinationCoordinate)
                                                }
                                            }
                                        }
                                        }
                                        }
                                    catch {
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    private func getCoordinate(from address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocodeAddress(address: address) { coordinate in
              completion(coordinate)
          }
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
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            guard let data = data else {
                print("Geocoding data is nil")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let geocodingResponse = try decoder.decode(GeocodingResponse.self, from: data)

                if let location = geocodingResponse.results.first?.geometry.location {
                    let coordinates = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
                    DispatchQueue.main.async {
                        completion(coordinates)
                    }
                } else {
                    print("Error parsing geocoding response")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error parsing geocoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    struct GeocodingResponse: Decodable {

        let results: [GeocodingResult]
    }

    struct GeocodingResult: Decodable {
        let formattedAddress: String?

        let geometry: Geometry
    }

    struct Geometry: Decodable {
        let location: Location
    }

    struct Location: Decodable {
        let lat: Double
        let lng: Double
    }
    // Add this structure definition alongside your existing code
    struct GooglePlacesResponse: Decodable {
        let results: [GooglePlace]
    }

    struct GooglePlace: Decodable {
        let geometry: GoogleGeometry?
    }

    struct GoogleGeometry: Decodable {
        let location: GoogleLocation?
    }

    struct GoogleLocation: Decodable {
        let lat: Double
        let lng: Double
    }


}

