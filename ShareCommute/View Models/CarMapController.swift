//
//  CarMapController.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 28/11/2023.
//

import SwiftUI
import UIKit
import GooglePlaces

class CarMapController: UIViewController,ObservableObject{
    
    public func saveEMG(source:String,distination:String) {
        
        
            
            
        }
        
        func saveCovoiturage( pointDepart: String, pointArrivee: String, tarif: Double, completion: @escaping (EmgCovoiturage?) -> Void) {
            // Define the URL of your Node.js endpoint
            let dateFormatter = ISO8601DateFormatter()
            let currentDate = dateFormatter.string(from: Date())
            
            let url = URL(string: "http://localhost:9090/covoiturage/saveCovoiturage")! // Replace with your actual server URL
            
            // Create the request body
            let requestBody: [String: Any] = [
                "id_cond": 0,
                "id_user": "656080221d51b314e6169893",
                "pointDepart": pointDepart,
                "pointArrivee": pointArrivee,
                "date": currentDate,
                "Tarif": tarif,
                "statut" : "Active",
                "typeCov": "Emergency"
            ]
            
            // Convert the request body to JSON data
            let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Create the URLSession task
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
        
        // Find
        
        func getListeByLocation(localisation: String, completion: @escaping (Result<[Driver], Error>) -> Void) {
            // Replace with your actual server URL
            let url = URL(string: "https://your-node-server-url/finddriver/\(localisation)")!
            
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
                    completion(.failure(error))
                }
            }
            
            // Start the URLSession task
            task.resume()
        }
        
        
        // Call the function to save the Covoiturage
        
        
        
        
    }
    
    

