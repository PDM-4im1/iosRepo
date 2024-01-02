//
//  LocationSearchViewModel.swift
//  SharedCommute
//
//  Created by nasrimootez on 2/1/2024.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment : String = "" {
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
      
        locationSearch(forLocalSearchCompletion: localSearch){response, error in
                
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    func computeDeliveryPrice(forType type: DeliveryType)-> Double {
        guard let destcoordinate = selectedLocationCoordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude,
                                      longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destcoordinate.latitude,
                                     longitude: destcoordinate.longitude)
        let tripDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    func getAddress(from coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    completion(nil)
                    return
                }
                var addressString = ""
                if let subLocality = placemark.name {
                    print("aaaaa")
                    addressString += subLocality + ", "
                }
                if let locality = placemark.locality {
                    print("bbbbb")
                    addressString += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    print("cccccc")
                    addressString += administrativeArea + ", "
                }
                if let country = placemark.country {
                    print("aaaaa")
                    addressString += country
                }
                completion(addressString)
            }
        }
        
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
