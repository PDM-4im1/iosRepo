//
//  CarMapController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import SwiftUI
import GooglePlaces

class CarMapController: UIViewController,ObservableObject {
    @Published var locationText: String = ""
    @Published var searchText: String = ""
    
    func sendData() {
        // Perform actions with the data
        print("Location Text: \(locationText)")
        print("Search Text: \(searchText)")
        
        // Example: Send the data to a server or perform any other desired operations
    }
    let placeFields: GMSPlaceField = [
        .name,
        .placeID,
        .formattedAddress,
        .coordinate,
        .phoneNumber,
        .website,
        // Add more fields as needed
    ]
    // Function to open the Autocomplete activity
    func openAutocompleteActivity() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Customize the appearance of the Autocomplete activity (optional)
        let autocompleteFilter = GMSAutocompleteFilter()
        autocompleteFilter.type = .address
        autocompleteController.autocompleteFilter = autocompleteFilter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // ...
    
    
    
   
}

extension CarMapController: GMSAutocompleteViewControllerDelegate {
    
    // Delegate method to handle the selected place from the Autocomplete activity
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Handle the selected place
        // You can access the place details from the `place` object
        
        dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to handle the user's cancellation of the Autocomplete activity
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        
        dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to handle when the Autocomplete activity is dismissed by the user
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
