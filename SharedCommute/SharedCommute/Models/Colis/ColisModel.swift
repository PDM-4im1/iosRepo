//
//  ColisModel.swift
//  SharedCommute
//
//  Created by nasrimootez on 2/1/2024.
//

import Foundation

struct ColisModelResponse: Decodable {
    var colis: [ColisModel]
}
struct ColisModel: Decodable, Identifiable {
    var id: Int
    var width: Int
    var height: Int
    var weight: Int
    var description: String
    var adresse: String
    var destination: String
    var receiverName: String
    var receiverPhone: String
    var etat: String
    var idLivreur: String?
    var idClient: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case height
        case width
        case weight
        case description
        case adresse
        case destination
        case receiverName
        case receiverPhone
        case etat
        case idLivreur
        case idClient
       
    }
}
