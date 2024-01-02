//
//  CovoiturageController.swift
//  ShareCommute
//
//  Created by Rihem Drissi on 15/12/2023.
//

import UIKit
import MessageUI

class CovoiturageController: UIViewController,ObservableObject,MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)

            switch result {
            case .cancelled:
                print("Email composition cancelled")
            case .saved:
                print("Email saved as draft")
            case .sent:
                print("Email sent successfully")
            case .failed:
                if let error = error {
                    print("Email composition failed with error: \(error.localizedDescription)")
                } else {
                    print("Email composition failed")
                }
            @unknown default:
                break
            }
        }
    func sendEmail(Mail: String, Covoiturage: EmgCovoiturage) {
           if MFMailComposeViewController.canSendMail() {
               let mailComposer = MFMailComposeViewController()
               mailComposer.mailComposeDelegate = self

               // Set up the email details
               print("Sending mail to:", Mail)
               mailComposer.setToRecipients([Mail])
               mailComposer.setSubject("Covoiturage Invitation")

               // Customize the body of the email with ride details and buttons
               let emailBody = """
               <p>Dear Driver,</p>
               <p>You have a new Emergency covoiturage:</p>
               <p>Ride Details: </p>
               <br>
               <p> From : \(Covoiturage.pointDepart)</p>
               <p> To :\(Covoiturage.pointArrivee)</p>
               <p> Tarif : \(Covoiturage.Tarif)</p>
               <p> Type : \(Covoiturage.typeCov)</p>
               """
               mailComposer.setMessageBody(emailBody, isHTML: true)

               // Present the mail composer
               self.present(mailComposer, animated: true, completion: nil)
           } else {
               // Handle the case where the device cannot send email
               print("Device cannot send email")
           }
       }
    func updateRide(Covoiturage: String,idcond: String) {
        let url = URL(string: "http://localhost:9090/covoiturage/edit/\(Covoiturage)")!

        // Create the request body
        let requestBody: [String: Any] = [
            "id_cond": idcond
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
    func fetchCovoiturage(UserId userId: String, completion: @escaping (EmgCovoiturage?) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/findCovoiturage/\(userId)"
        
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
                    let decodedUser = try JSONDecoder().decode(EmgCovoiturage.self, from: jsonData)
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
   

}
