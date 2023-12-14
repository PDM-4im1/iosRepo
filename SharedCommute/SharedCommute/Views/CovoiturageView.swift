//
//  CovoiturageView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI

struct CovoiturageView: View {
    @State private var drivers: [Driver] = []

    var body: some View {
        List(drivers) { driver in
            EmgDriverCell(driver: driver)
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 8).padding()
        .onAppear {
            // Fetch the list of drivers when the view appears
            fetchDrivers()
        }
    }

    func fetchDrivers() {
        // Replace with your actual server URL and coordinate values
        let latitude = 36.900914
        let longitude = 10.19001
        let urlString = "http://localhost:9090/covoiturage/finddriver?latitude=\(latitude)&longitude=\(longitude)"
        
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
                // Decode the JSON data into an array of Driver
                let decodedDrivers = try JSONDecoder().decode([Driver].self, from: data)
                DispatchQueue.main.async {
                    self.drivers = decodedDrivers
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }   } 
    

struct CovoiturageView_Previews: PreviewProvider {
    static var previews: some View {
        CovoiturageView()
    }
}
