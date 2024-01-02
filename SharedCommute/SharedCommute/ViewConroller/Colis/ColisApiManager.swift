import Foundation

class ColisApiManager {
    func getUnassignedColis(completion: @escaping (Result<[ColisModel], Error>) -> Void) {
      
        
        let url = URL(string: "http://localhost:9090/colis/getunassigned")!
        URLSession.shared.dataTask(with: url) { data, response, error in
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
                let colis = try decoder.decode([ColisModel].self, from: data)
                print(colis)
                completion(.success(colis))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    func assignLivreur(id: String, idLivreur: String, completion: @escaping (Error?) -> Void) {
            let url = URL(string: "http://localhost:9090/colis/assign")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let params: [String: Any] = [
                "id": id,
                "idLivreur": idLivreur
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    // Check response status code or other validation if needed
                    
                    completion(nil)
                }.resume()
            } catch {
                completion(error)
            }
        }
    func getLivreurColis(idLivreur: String, completion: @escaping (Result<[ColisModel], Error>) -> Void) {
        let urlString = "http://localhost:9090/colis/getColisByLivreur"
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }

        let params: [String: Any] = ["idLivreur": idLivreur]
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
                    let colisList = try decoder.decode([ColisModel].self, from: data)
                    completion(.success(colisList))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    func changeEtatColis(id: String, etat: String, completion: @escaping (Error?) -> Void) {
        let urlString = "http://localhost:9090/colis/changeEtatColis"
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(urlError)
            return
        }
        
        let params: [String: Any] = [
            "id": id,
            "etat": etat
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                // Check response status code or other validation if needed
                
                completion(nil)
            }.resume()
        } catch {
            completion(error)
        }
    }
    func createColis(width: Int, weight: Int, height: Int, description: String, adresse: String, destination: String, receiverName: String, receiverPhone: String, idClient : String, completion: @escaping (Error?) -> Void) {
        let urlString = "http://localhost:9090/colis"
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(urlError)
            return
        }
        
        let params: [String: Any] = [
            "height": height,
            "width": width,
            "weight": weight,
            "description": description,
            "adresse": adresse,
            "destination": destination,
            "receiverName": receiverName,
            "receiverPhone": receiverPhone,
            "idClient" : idClient
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                // Check response status code or other validation if needed
                
                completion(nil)
            }.resume()
        } catch {
            completion(error)
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
