//
//  SignInViewModel.swift
//  login
//
//  Created by Mac Mini on 30/11/2023.
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    
    @Published var isLoading: Bool = false
    @Published var isNavigationActive: Bool = false
    
  //  private let apiManager = APIManager.shared
    
    func login() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
        }
        // Create a JSON body with the user's credentials
        let apiUrl = URL(string: "http://localhost:9090/user/signin")!
        
        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            var request = URLRequest(url: apiUrl)
            
            // Set the request method to POST
            request.httpMethod = "POST"
            
            // Set the request body with the JSON data
            request.httpBody = jsonData
            
            // Set the request header to indicate JSON content
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    // Parse and handle the response data
                    // Note: You should handle this according to your API response format
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        //print("Response: \(jsonResponse)")
                        print(jsonResponse)
                        if let jsonDictionary = jsonResponse as? [String: Any], let token = jsonDictionary["token"] as? String {
                            print("Token: \(token)")
                            // Save the token to your session or any storage mechanism you prefer
                            // Example using UserDefaults:
                            UserDefaults.standard.set(token, forKey: "accessToken")
                            
                        }
                        // You can update your UI or perform other actions based on the response
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isNavigationActive = true
                }
            }.resume()
            
        } catch {
            print("error taa do")
        }
        
        
    }
    
}
class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var role = ["admin" ,"driver", "client" ,"deliveryMan"]
    @Published var phoneNumber: String = ""
    @Published var name: String = ""
    @Published var fname: String = ""
    @Published var age: String = ""
    @Published var isLoading: Bool = false
    @Published var isNavigationActive: Bool = false
    
  //  private let apiManager = APIManager.shared
    
    func signup() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
        }
        
        // Create a JSON body with the user's credentials
        let apiUrl = URL(string: "http://localhost:9090/user/signup")!
        
        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
            "Phone_number":phoneNumber,
            "role":role,
            "name":name,
            "first_name":fname,
            "age" : age,
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            var request = URLRequest(url: apiUrl)
            
            // Set the request method to POST
            request.httpMethod = "POST"
            
            // Set the request body with the JSON data
            request.httpBody = jsonData
            
            // Set the request header to indicate JSON content
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    // Parse and handle the response data
                    // Note: You should handle this according to your API response format
                    do {
                        _ = try JSONSerialization.jsonObject(with: data, options: [])
                     
                        // You can update your UI or perform other actions based on the response
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isNavigationActive = true
                }
            }.resume()
            
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
        }
    }
}


