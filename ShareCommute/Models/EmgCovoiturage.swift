//
//  EmgCovoiturage.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import Foundation
struct EmgCovoiturage: Identifiable, Decodable {
    let id: String
          let id_cond: String
          let id_user: String
          let pointDepart: String
          let pointArrivee: String
          let dateCovoiturage: String?
          let Tarif: Double
          let statut: String?
      let typecov : String 

          private enum CodingKeys: String, CodingKey {
              case id = "_id"
              case id_cond = "id_cond"
              case id_user
              case pointDepart = "pointDepart"
              case pointArrivee = "pointArrivee"
              case dateCovoiturage = "dateCovoirurage"
              case Tarif = "Tarif"
              case statut
              case typecov = "typeCov"

          }
}
