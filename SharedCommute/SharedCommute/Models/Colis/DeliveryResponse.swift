//
//  DeliveryResponse.swift
//  project
//
//  Created by Apple Esprit on 30/11/2023.
//

import Foundation
struct ColisResponse: Decodable {
    var colis: [Colis]
}

struct Colis: Decodable, Identifiable {
    var id: String
    var width: Int
    var height: Int
    var weight: Int
    var description: String
    var adresse: String
    var destination: String
    var receiverName: String
    var receiverPhone: String
    var v:Int
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case height
        case width
        case weight
        case description
        case adresse
        case destination
        case receiverName
        case receiverPhone
        case v = "__v"
       
    }
}
