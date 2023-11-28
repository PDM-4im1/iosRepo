import SwiftUI
import GoogleMaps




struct CovoiturageTableView: View {
    let conducteurs = [
        Conducteur(idMoyenTransport: "1", idUser: "1", pointDepart: "A", pointArrivee: "B", localisation: "C"),
                Conducteur(idMoyenTransport: "2", idUser: "2", pointDepart: "X", pointArrivee: "Y", localisation: "Z"),
                Conducteur(idMoyenTransport: "3", idUser: "3", pointDepart: "M", pointArrivee: "N", localisation: "O"),
            ]
    
    let users = [
        User(email: "ahmed@eszzin.com", password: "", phoneNumber: 20235654, role:"", name: "Ahmed" , firstName: "", age: 20),
        User(email: "ahmed@eszzin.com", password: "", phoneNumber: 20235654, role:"", name: "Mootez" , firstName: "Nasri", age: 20),
        User(email: "ahmed@eszzin.com", password: "", phoneNumber: 20235654, role:"", name: "Louay" , firstName: "", age: 20),
        // Add more users as needed
    ]

    let moyensDeTransport = [
        MoyenDeTransport(marque: "Toyota", type: "Sedan", matricule: "ABC123", image: "car_image", trajet: "A to B", idConducteur: "1"),
        MoyenDeTransport(marque: "Bmw", type: "Sedan", matricule: "ABC123", image: "car_image", trajet: "A to B", idConducteur: "1"),
        MoyenDeTransport(marque: "Audi", type: "Sedan", matricule: "ABC123", image: "car_image", trajet: "A to B", idConducteur: "1"),
        // Add more moyensDeTransport as needed
    ]

    var body: some View {
        List(conducteurs.indices) { index in
            CovoiturageCell(
                conducteur: conducteurs[index],
                user: users[index],
                moyenDeTransport: moyensDeTransport[index]
            )
        }
    }
}

struct CovoiturageTableView_Previews: PreviewProvider {
    static var previews: some View {
        CovoiturageTableView()
    }
}
