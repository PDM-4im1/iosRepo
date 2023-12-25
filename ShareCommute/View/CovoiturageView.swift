//
//  CovoiturageView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI
import MessageUI

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
                    isLoading = true
                   // controller.sendEmail(Mail: email,Covoiturage:Emrgency!)
                    controller.fetchCovoiturage(UserId: Emrgency!.id) { covoiturage in
                        if let covoiturage = covoiturage {
                            switch covoiturage.statut {
                                               case "Accept":
                                                   showPaymentView = true
                                               case "Refuse":
                                isLoading = false
                                showPaymentView = false
                                                   print("Ride refused")
                                               case "Active":
                                                   isLoading = true
                                                   print("Ride is still active")
                                               default:
                                                   break
                                               }
                        } else {
                            print("User not found")
                        }
                        
                    }
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
                    //badelha
                     
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 8).padding()
        .onAppear {
            // Fetch the list of drivers when the view appears
            fetchDrivers()
            print(drivers)
        }
    }

    

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
    func updateRid(Cond: String ,idCond:String){
        let url = URL(string: "http://localhost:9090/covoiturage/edit/\(Emrgency!.id)")!
        // Create the request body
        let requestBody: [String: Any] = [
            "id_cond": idCond
        ]
        
        // Convert the request body to JSON data
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the URLSession task
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching Transport: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when fetching Transport.")
                return
            }
            do {
                let decodedCovoiturage = try JSONDecoder().decode(EmgCovoiturage.self, from: data)
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
