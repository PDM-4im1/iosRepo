//
//  ClientRequest.swift
//  SharedCommute
//
//  Created by mootenasri on 1/1/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct ClientRequest: Identifiable, Codable {
    var id: String?
    var status: String?
    var client: String?
    var covoiturage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case client
        case covoiturage
    }
}
