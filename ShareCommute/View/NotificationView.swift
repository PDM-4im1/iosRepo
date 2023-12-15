//
//  NotificationView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//

import SwiftUI

struct NotificationView: View {
    @State private var Covoiturage: [EmgCovoiturage] = []
      @State private var From = "None"
      @State private var To = "None"
      @State private var Price = "None"
    @State private var idCov = ""

      var body: some View {
          VStack(alignment: .leading, spacing: 4) {
              HStack(spacing: 16) {
                  Image("siren")
                      .resizable()
                      .frame(width: 48, height: 48)
                  
                  VStack(alignment: .leading, spacing: 5) {
                      Text("Emergency Ride")
                          .font(.headline)
                          .foregroundColor(.black)
                      
                      Text("Do you accept this ride?")
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                      
                      Text("From: \(From)")
                          .font(.footnote)
                          .foregroundColor(.secondary)
                      
                      Text("To: \(To)")
                          .font(.footnote)
                          .foregroundColor(.secondary)
                      
                      Text("Price : \(Price)")
                          .font(.footnote)
                          .foregroundColor(.secondary)
                  }
              }
              
              HStack(spacing: 4) {
                  Button(action: {
                      updateRidA(Covoiturage: idCov)
                  }) {
                      Text("Accept")
                          .foregroundColor(.white)
                          .frame(minWidth: 0, maxWidth: .infinity)
                          .padding()
                          .background(Color.green)
                          .cornerRadius(8)
                  }
                  
                  Button(action: {
                      updateRidR(Covoiturage: idCov)
                  }) {
                      Text("Decline")
                          .foregroundColor(.white)
                          .frame(minWidth: 0, maxWidth: .infinity)
                          .padding()
                          .background(Color.red)
                          .cornerRadius(8)
                  }
              }
          }
          .padding()
          .background(Color.white)
          .onAppear {
              getlastCovoiturage() { covoiturage in
                  if let covoiturage = covoiturage {
                      DispatchQueue.main.async {
                          print(covoiturage)
                          From = covoiturage.pointDepart
                          To = covoiturage.pointArrivee
                          Price = String(covoiturage.Tarif)
                          idCov = covoiturage.id
                      }
                  } else {
                      print("User not found")
                  }
              }
          }
      }
    func updateRidA(Covoiturage: String) {
        let url = URL(string: "http://localhost:9090/covoiturage/edit/\(Covoiturage)")!

        // Create the request body
        let requestBody: [String: Any] = [
            "statut": "Accept"
        ]

        // Convert the request body to JSON data
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the URLSession task
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating ride status: \(error.localizedDescription)")
                return
            }

            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    // Success
                    print("Ride status updated successfully!")
                } else {
                    // Error
                    print("Error updating ride status. Status code: \(httpResponse.statusCode)")
                }
            } else {
                // Unexpected response
                print("Unexpected response when updating ride status.")
            }
        }.resume()
    }

    func updateRidR(Covoiturage:String){
        let url = URL(string: "http://localhost:9090/covoiturage/edit/\(Covoiturage)")!
        // Create the request body
        let requestBody: [String: Any] = [
            "statut": "Refuse"
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
                print("Error updating ride status: \(error.localizedDescription)")
                return
            }

            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    // Success
                    print("Ride status updated successfully!")
                } else {
                    // Error
                    print("Error updating ride status. Status code: \(httpResponse.statusCode)")
                }
            } else {
                // Unexpected response
                print("Unexpected response when updating ride status.")
            }
        }.resume()
    }
    func getlastCovoiturage( completion: @escaping (EmgCovoiturage?) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/LastCov"
        
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
                let decodedCovoiturage = try JSONDecoder().decode(EmgCovoiturage.self, from: data)
                completion(decodedCovoiturage)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
