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
        
        saveCovoiturage( pointDepart: source, pointArrivee: distination, tarif: 20.5){ error in
            if let error = error {
                print("Error saving Covoiturage: \(error.localizedDescription)")
            } else {
                print("Covoiturage saved successfully")
            }
            
            
        }
        
        func saveCovoiturage( pointDepart: String, pointArrivee: String, tarif: Double, completion: @escaping (Error?) -> Void) {
            // Define the URL of your Node.js endpoint
            let dateFormatter = ISO8601DateFormatter()
            let currentDate = dateFormatter.string(from: Date())
            
            let url = URL(string: "http://localhost:9090/covoiturage/saveCovoiturage")! // Replace with your actual server URL
            
            // Create the request body
            let requestBody: [String: Any] = [
                "id_cond": 0,
                "id_user": 3,
                "pointDepart": "",
                "pointArrivee": "",
                "date": currentDate,
                "Tarif": tarif
            ]
            
            // Convert the request body to JSON data
            let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Create the URLSession task
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    // Handle the error
                    completion(error)
                    return
                }
                
                // Check if the response status code indicates success
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    // Request was successful
                    completion(nil)
                } else {
                    // Request failed with an error
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    let error = NSError(domain: "CovoiturageErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(error)
                }
            }
            
            // Start the URLSession task
            task.resume()
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
    
    
}
