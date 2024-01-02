//
//  Delivery.swift
//  project
//
//  Created by Apple Esprit on 29/11/2023.
//

import Foundation
struct Delivery:Identifiable{
    let id = UUID()
    var width: Int
    var height: Int
    var weight: Int
    var description: String
    var adresse: String
    var destination: String
    var receiverName: String
    var receiverPhone: String
    init(height: Int, width: Int, receiverPhone: String, destination: String, weight: Int,description: String,adresse: String,receiverName: String) {
        self.height = height
        self.width = width
        self.weight = weight
        self.destination = destination
        self.receiverPhone = receiverPhone
        self.receiverName = receiverName
        self.description = description
        self.adresse = adresse
    }

}

