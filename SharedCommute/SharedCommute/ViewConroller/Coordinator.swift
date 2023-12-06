//
//  Coordinator.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 6/12/2023.
//

import GoogleMaps
import GooglePlaces
class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        var selectedField: String = ""

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            if selectedField == "source" {
                source = place.formattedAddress ?? ""
            } else if selectedField == "destination" {
                destination = place.formattedAddress ?? ""
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
