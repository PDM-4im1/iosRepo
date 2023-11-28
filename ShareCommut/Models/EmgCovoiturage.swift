//
//  EmgCovoiturage.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import Foundation
struct EmgCovoiturage: Identifiable {
    let id = UUID()
    let id_cond: String
    let id_user: String
    let pointDepart: String
    let pointArrivee: String
    let Date: String
    let Tarif: String
}

