//
//  CarMapController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import SwiftUI
import UIKit
import GooglePlaces
import CoreLocation

class CarMapController: UIViewController,ObservableObject{
    
    
    public func saveEMG(source:String,distination:String) {
        
        
            
            
        }
        
    func saveCovoiturage(iduser : String,pointDepart: String, pointArrivee: String, tarif: Double, completion: @escaping (EmgCovoiturage?) -> Void) {
        let dateFormatter = ISO8601DateFormatter()
        let currentDate = dateFormatter.string(from: Date())

        let url = URL(string: "http://localhost:9090/covoiturage/saveCovoiturage")!
        
        let requestBody: [String: Any] = [
            "id_cond": "",
            "id_user": "656080221d51b314e6169893",
            "pointDepart": pointDepart,
            "pointArrivee": pointArrivee,
            "dateCovoirurage": currentDate,
            "Tarif": tarif,
            "statut" : "Active",
            "typeCov": "Emergency"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(request)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching Transport: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                print("C")
                guard let data = data else {
                    print("No data received when fetching Transport.")
                    completion(nil)
                    return
                }

                do {
                    print("Received Saved Data:", String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")
                    let decoder = JSONDecoder()
                    let decodedCovoiturage = try decoder.decode(EmgCovoiturage.self, from: data)
                    completion(decodedCovoiturage)

                      print("Data saved:", decodedCovoiturage)
                  } catch {
                      print("Error decoding Covoiturages JSON: \(error)")
                      completion(nil)
                  }
            }.resume()
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            completion(nil)
        }
    }

            
            // Find
 
   
        func getListeByLocation(localisation: String, completion: @escaping (Result<[Driver], Error>) -> Void) {
            // Replace with your actual server URL
            let url = URL(string: "https://localhost:9090/covoiturage/finddriver/\(localisation)")!
            
            // Create the URLSession task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    // Assuming Conducteur is Codable
                    let conducteurs = try JSONDecoder().decode([Driver].self, from: data)
                    completion(.success(conducteurs))
                } catch {
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")

                    completion(.failure(error))
                }
            }
            
            // Start the URLSession task
            task.resume()
        }
        
        
        // Call the function to save the Covoiturage
        
        
        
        
    }
    
    
