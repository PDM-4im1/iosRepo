//
//  Driver.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import Foundation
struct Driver: Identifiable,Decodable {
    let id :String
       let idMoyenTransport: String
       let idUser: String
       let pointDepart: String
       let pointArrivee: String
       let localisation: String
    
    private enum CodingKeys: String, CodingKey {
           case id = "_id"
           case idMoyenTransport = "id_moyen_transpor"
           case idUser = "id_user"
           case pointDepart = "pointDepart"
           case pointArrivee = "pointArrivee"
           case localisation = "localisation"
       }
    
}
