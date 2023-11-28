//
//  CarMapController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import SwiftUI

class CarMapController: ObservableObject {
    @Published var locationText: String = ""
    @Published var searchText: String = ""
    
    func sendData() {
        // Perform actions with the data
        print("Location Text: \(locationText)")
        print("Search Text: \(searchText)")
        
        // Example: Send the data to a server or perform any other desired operations
    }
}

