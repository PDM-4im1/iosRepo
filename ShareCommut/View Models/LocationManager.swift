//
//  LocationManager.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 6/12/2023.
//

import SwiftUI
import CoreLocation
import MapKit
// combin Framework to watch textfield change
import Combine

class LocationManager: NSObject,ObservableObject,MKMapViewDelegate,CLLocationManagerDelegate {
   @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    //search bar
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    override init(){
        super.init()
        //Setting Delegates
        manager.delegate = self
        mapView.delegate = self
        
        //Requesting Location Access
        manager.requestWhenInUseAuthorization()
        
        //Search Texfield Watching
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.fetchPlaces(value: value)
            })
    }
    func fetchPlaces(value: String){
        //print(value)
        //fetching places using MKLoaclSearch
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                //Mainactor to publidh chnges
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({item -> CLPlacemark? in
                        return item.placemark
                        
                    })
                })
            }
            catch{
                //handle error
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else{return}
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError(){
        //
    }
}


