import Foundation
struct Covoiturage: Identifiable, Decodable,Encodable,Equatable {
    let id: String?
        let id_cond: String
        let id_user: String
        let pointDepart: String
        let pointArrivee: String
        let dateCovoiturage: String?
        let Tarif: Double?
        let statut: String?
    let typecov : String = "Covoiturage"

        private enum CodingKeys: String, CodingKey {
            case id = "_id"
            case id_cond = "id_cond"
            case id_user
            case pointDepart = "pointDepart"
            case pointArrivee = "pointArrivee"
            case dateCovoiturage = "dateCovoiturage"
            case Tarif = "Tarif"
            case statut 
            case typecov = "typeCov"

        }
}


