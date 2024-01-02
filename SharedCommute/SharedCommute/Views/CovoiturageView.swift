//
//  CovoiturageView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI
import MessageUI
import Firebase
import FirebaseFirestore

struct DriverRow: View {
    var driver: Driver
    @State private var name = "No Name"
    @State private var phone = "No Number"
    @State private var car = "No Car"
    @Binding private var mail :String
    init(driver: Driver, mail: Binding<String>) {
            self.driver = driver
            self._mail = mail
        }

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 55, height: 58)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                    Text(name)
                }
                
                HStack {
                    Image(systemName: "phone")
                    Text(phone)
                }
                
                HStack {
                    Image(systemName: "car")
                    Text(car)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text("7.500 DT")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onAppear {
            fetchUser(UserId: driver.idUser) { user in
                if let user = user {
                    DispatchQueue.main.async {
                        print(user)
                        name = user.name + " " + user.firstName
                        phone = user.phoneNumber
                        mail = user.email
                    }
                } else {
                    print("User not found")
                }
            }
            fetchTransprt(TransportId: driver.idMoyenTransport) { transport in
                if let transport = transport{
                    DispatchQueue.main.async {
                        print(transport)
                        car = transport.marque ?? "no"
                    }
                } else {
                    print("car not found")
                }
                
            }
        }
    }
    func fetchUser(UserId userId: String, completion: @escaping (User?) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/findUser/\(userId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching User: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received when fetching User.")
                completion(nil)
                return
            }
       
            
            do {
                // Decode the JSON data into a dictionary
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Error converting JSON to dictionary.")
                    completion(nil)
                    return
                }
               
                // Decode the dictionary into a User object
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: []) {
                    let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
                    completion(decodedUser)
                } else {
                    print("Error decoding dictionary into User.")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchTransprt(TransportId: String, completion: @escaping (MoyenDeTransport?) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/findMoyenDeTransportById/\(TransportId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Transport: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received when fetching Transport.")
                completion(nil)
                return
            }
            print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")
            do {
                let decodedTransport = try JSONDecoder().decode(MoyenDeTransport.self, from: data)
                completion(decodedTransport)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

}

struct CovoiturageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var pendingRides: ClientRequest?
    @State private var clientRequest: ClientRequest?
    @State private var selectedDriver: Driver? = nil
    @State private var isLoading = false
    @State private var email = ""
    @StateObject private var controller = CovoiturageController()
    @State private var drivers: [Driver] = []
    @State private var showPaymentView = false
    @Binding var Emrgency: EmgCovoiturage?
        init(Emrgency: Binding<EmgCovoiturage?>) {
            _Emrgency = Emrgency
        }

    var body: some View {
        List {
            ForEach(drivers) { driver in
                DriverRow(driver: driver, mail: $email)
                
                Button(action: {
                   
                    print("datacoiviturage driver :", Emrgency!)
                    //selectedDriver = driver
                    sendRideRequest(driver: driver)
                    controller.updateRide(Covoiturage:Emrgency!.id! ,idcond: driver.id)
                    isLoading = true
                    }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                }
                .frame(height: 35)
                .background(Color.green)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .sheet(isPresented: $showPaymentView) {
                    PaymentSelectionView()
                    LoadingView(isLoading: $isLoading)
                    //badelha
                     
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 8).padding()
        .onAppear {
            // Fetch the list of drivers when the view appears
            fetchDrivers()
            retryFetchingClientRequest()
            print(drivers)
            
            
        }
        .sheet(isPresented: $isLoading) {
            LoadingView(isLoading: $isLoading)
                }
               
    }
    func retryFetchingClientRequest() {
        getClientRequest { [self] (clientRequest, error) in
            if let error = error {
                print("Error fetching client request: \(error.localizedDescription)")
                // Handle the error as needed
            } else if clientRequest == nil {
                // If no client request is found, retry after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    retryFetchingClientRequest()
                }
            } else {
                isLoading = false
                print("Client request found: \(clientRequest)")
                // Do something with the client request
            }
        }
    }
    func fetchClientRequest() {
        isLoading = false
           getClientRequest { (result, error) in
               if let error = error {
                   print("Error fetching client request: \(error.localizedDescription)")
                  // isLoading = false
                   return
               }
               
               if let result = result {
                   self.clientRequest = result
              

                   // Check the status and navigate accordingly
                   if result.status == "Accept" {
                       
                       // Navigate to another view
                       showPaymentView = true
                   } else if result.status == "Decline" {
                       //isLoading = false
                       // Handle declined state or simply dismiss the view
                       presentationMode.wrappedValue.dismiss()
                   } else {
                       //isLoading = false
                       print("Unknown status: \(String(describing: result.status))")
                   }
               } else {
                   //isLoading = false
                   print("No client request found.")
               }
           }
       }
    
    func sendRideRequest(driver: Driver) {
        let db = Firestore.firestore()

        // Create a new document in "rideRequests" collection
        db.collection("rideRequests").addDocument(data: [
            "id": Emrgency?.id ,
            "id_user": Emrgency?.id_user!,
            "id_cond": driver.id,
            "pointDepart": Emrgency?.pointDepart!,
            "pointArrivee": Emrgency?.pointArrivee!,
            "Tarif": Emrgency?.Tarif,
            "status": "pending",
            // Add any other relevant data from EmgCovoiturage
        ]) { err in
            if let err = err {
                print("Error sending ride request: \(err)")
            } else {
                print("Ride request sent successfully")
               // presentationMode.wrappedValue.dismiss() // Dismiss the view after sending the request
            }
        }
    }

    func getClientRequest(completion: @escaping (ClientRequest?, Error?) -> Void) {
        let db = Firestore.firestore()
print(Emrgency?.id)
        // Create a reference to the "clientrequest" collection
        let collectionRef = db.collection("clientrequest")

        // Query to fetch the document where id_user is equal to the provided user ID
        let query = collectionRef.whereField("covoiturage", isEqualTo: Emrgency?.id)

        // Execute the query
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching client request: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let document = querySnapshot?.documents.first else {
                print("No document found for user ID: ")
                completion(nil, nil)
                return
            }

            do {
                // Attempt to decode the Firestore document into a ClientRequest object
                if let clientRequest = try document.data(as: ClientRequest?.self) {
                    completion(clientRequest, nil)
                } else {
                    // Handle the case where the decoding succeeded but the resulting object is nil
                    print("Decoding succeeded but returned nil for ClientRequest")
                    completion(nil, nil)
                }
            } catch {
                // Handle any errors that occur during the decoding process
                print("Error decoding ClientRequest: \(error)")
                completion(nil, error)
            }
        }
    }


     // Ensure this is an array of ClientRequest objects


    func fetchDrivers() {
        // Replace with your actual server URL and coordinate values
        let latitude = 36.900914
        let longitude = 10.19001
        let urlString = "http://localhost:9090/covoiturage/finddriver/latitude=\(latitude),longitude=\(longitude)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching drivers: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when fetching drivers.")
                return
            }
           
            
            do {
                // Decode the JSON data into an array of dictionaries
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Error converting JSON to array of dictionaries.")
                    return
                }
                
                // Decode each dictionary into a Driver object
                let decodedDrivers = jsonArray.compactMap { dictionary -> Driver? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                        return try JSONDecoder().decode(Driver.self, from: jsonData)
                    } catch {
                        print("Error decoding dictionary into Driver: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.drivers = decodedDrivers
                    print(self.drivers)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    

}



struct CovoiturageView_Previews: PreviewProvider {
    static var previews: some View {
        CovoiturageView(Emrgency: .constant(nil)).environmentObject(CovoiturageController())
    }
}
