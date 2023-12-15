//
//  Driverrelatedview.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 15/12/2023.
//

import SwiftUI

struct DriverView: View {
    @State private var driver: Driver?
        @State private var user: User?
        @State private var moyenDeTransport: MoyenDeTransport?
        
        let driverID: String  // Added parameter
        
        init(driverID: String) {
            self.driverID = driverID
        }
    
    
    
    var body: some View {
        VStack {
            if let driver = driver {
                Text("Driver Information")
                    .font(.title)
                if let user = user {
                    
                    Text("Name: \(user.firstName)")
                    Text("Phone Number: \(user.phoneNumber)")
                    Text("Transport Type: \(moyenDeTransport?.type ?? "N/A")")
                    
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            fetchDriverInformation(driverID: driverID) // Replace with actual driver ID
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
    
    func fetchTransprt(TransportId: String, completion: @escaping (Result<MoyenDeTransport, Error>) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/findMoyenDeTransportById/\(TransportId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Transport: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received when fetching Transport.")
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")
            
            do {
                let decodedTransport = try JSONDecoder().decode(MoyenDeTransport.self, from: data)
                completion(.success(decodedTransport))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }


    func fetchDriverInformation(driverID: String) {
     
        let urlString = "http://localhost:9090/covoiturage/findConducteurById/\(driverID)"
        
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
                let decodedDriver = try JSONDecoder().decode(Driver.self, from: data)
                
                DispatchQueue.main.async {
                    self.driver = decodedDriver
                    print(self.driver)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            // Fetch user information based on driver.idUser
                 fetchUser(UserId: driverID) { fetchedUser in
                     if let user = fetchedUser {
                         self.user = user
                     } else {
                         print("Failed to fetch user information.")
                     }
                 }
                 
                 // Fetch transport information based on driver.idMoyenTransport
                 fetchTransprt(TransportId: driverID) { result in
                     switch result {
                     case .success(let transport):
                         self.moyenDeTransport = transport
                     case .failure(let error):
                         print("Failed to fetch transport information: \(error.localizedDescription)")
                     }
                 }
             
        }.resume()
    }
}


struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView(driverID: "65798eb63ed6f3fb203527e1")
    }
}
