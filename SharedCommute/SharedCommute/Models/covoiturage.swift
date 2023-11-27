import Foundation

struct covoiturage:Identifiable{
    let id = UUID()
    let idCond: String
        let idUser: String
        let pointDepart: String
        let pointArrivee: String
        let date: String
        let tarif: String
    init(idCond: String, idUser: String, pointDepart: String, pointArrivee: String, date: String, tarif: String) {
        self.idCond = idCond
        self.idUser = idUser
        self.pointDepart = pointDepart
        self.pointArrivee = pointArrivee
        self.date = date
        self.tarif = tarif
    }
}
