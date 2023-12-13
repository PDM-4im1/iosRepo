//
//  MoyenDeTransport.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 8/12/2023.
//

import Foundation
class MoyenDeTransport:Identifiable,Decodable {
    let id:String
    let marque: String?
    let type: String?
    let matricule: String?
    let image: String?
    let trajet: String?
    let idConducteur: String?


    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case marque = "marque"
        case type = "type"
        case matricule = "matricule"
        case image = "image"
        case trajet = "trajet"
        case idConducteur = "id_conducteur"
    }
}
