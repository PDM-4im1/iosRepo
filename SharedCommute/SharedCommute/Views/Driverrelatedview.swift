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
    
    var body: some View {
        VStack {
            if let driver = driver {
                Text("Driver Information")
                    .font(.title)
                
                Text("Name: \(user!.firstName)")
                Text("Phone Number: \(user!.phoneNumber)")
                
                
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            fetchDriverInformation(driverID: "65798eb63ed6f3fb203527e1") // Replace with actual driver ID
        }
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
        }.resume()
    }
}


struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}
