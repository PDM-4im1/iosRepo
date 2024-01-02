//
//  ColisModelViewModel.swift
//  project
//
//  Created by Apple Esprit on 8/12/2023.
//

import Foundation


class ColisModelViewModel: ObservableObject {
    @Published var colisList: [ColisModel] = []
    @Published var errorMessage: String = ""

    func fetchUnassignedColis() {
        ColisApiManager().getUnassignedColis { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let colis):
                    self.colisList = colis
                case .failure(let error):
                    self.errorMessage = "Error fetching Colis: \(error.localizedDescription)"
                }
            }
        }
    }
    func assignLivreur(id: String, idLivreur: String) {
        
          ColisApiManager().assignLivreur(id: id, idLivreur: idLivreur) { error in
              DispatchQueue.main.async {
                  if let error = error {
                      self.errorMessage = "Error assigning Livreur: \(error.localizedDescription)"
                  } else {
                      // Handle success scenario if needed
                  }
              }
          }
      }
    func getLivreurColis(livreurId: String) {
        ColisApiManager().getLivreurColis(idLivreur: livreurId) { result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let colis):
                       self.colisList = colis
                   case .failure(let error):
                       self.errorMessage = "Error fetching Livreur Colis: \(error.localizedDescription)"
                   }
               }
           }
       }
    func changeEtatColis(id: String, etat: String) {
        ColisApiManager().changeEtatColis(id: id, etat: etat) { error in
            DispatchQueue.main.async {
                    
                    
                  
                if let error = error {
                    self.errorMessage = "Error changing Colis state: \(error.localizedDescription)"
                } else {
                    // Handle success scenario if needed
                }
            }
        }
    }
    func createColis(width: Int, weight: Int, height: Int, description: String, adresse: String, destination: String, receiverName: String, receiverPhone: String , idClient : String) {
        ColisApiManager().createColis(width: width, weight: weight,height: height, description: description, adresse: adresse, destination: destination, receiverName: receiverName, receiverPhone: receiverPhone , idClient: idClient) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error creating Colis: \(error.localizedDescription)"
                } else {
                    // Handle success scenario if needed
                    // You may want to refresh the colis list or update the UI here
                }
            }
        }
    }
    func getColis(id: String, completion: @escaping (Result<ColisModel, Error>) -> Void) {
            let urlString = "http://localhost:9090/colis/getColis"
            guard let url = URL(string: urlString) else {
                let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(.failure(urlError))
                return
            }
            
            let params: [String: Any] = [
                "id": id
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            let unknownError = NSError(domain: "", code: -1, userInfo: nil)
                            completion(.failure(unknownError))
                        }
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let colis = try decoder.decode(ColisModel.self, from: data)
                        completion(.success(colis))
                    } catch {
                        completion(.failure(error))
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }


}

