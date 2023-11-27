import Foundation

struct Conducteur:Identifiable{
    let id = UUID()
    let idMoyenTransport: String
    let idUser: String
    let pointDepart: String
    let pointArrivee: String
    let localisation: String
    init(idMoyenTransport: String, idUser: String, pointDepart: String, pointArrivee: String, localisation: String) {
        self.idMoyenTransport = idMoyenTransport
        self.idUser = idUser
        self.pointDepart = pointDepart
        self.pointArrivee = pointArrivee
        self.localisation = localisation
    }

}
