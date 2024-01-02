//
//  EmgCovoiturage.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct EmgCovoiturage: Identifiable, Codable {
    var id: String?
    let id_cond: String?
    let id_user: String?
    let pointDepart: String?
    let pointArrivee: String?
    let dateCovoirurage: String? // Corrected property name
    let Tarif: Double?
    let statut: String?
    let typeCov: String? // Corrected property name

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case id_cond = "id_cond"
        case id_user = "id_user"
        case pointDepart = "pointDepart"
        case pointArrivee = "pointArrivee"
        case dateCovoirurage = "dateCovoirurage" // Corrected key
        case Tarif = "Tarif"
        case statut = "statut"
        case typeCov = "typeCov" // Corrected key
    }
}
