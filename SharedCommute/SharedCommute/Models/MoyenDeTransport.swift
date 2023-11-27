
import Foundation

class MoyenDeTransport:Identifiable{
    let id = UUID()

    let marque: String
    let type: String
    let matricule: String
    let image: String
    let trajet: String
    let idConducteur: String



    init(marque: String, type: String, matricule: String, image: String, trajet: String, idConducteur: String) {
        self.marque = marque
        self.type = type
        self.matricule = matricule
        self.image = image
        self.trajet = trajet
        self.idConducteur = idConducteur
    }
}
