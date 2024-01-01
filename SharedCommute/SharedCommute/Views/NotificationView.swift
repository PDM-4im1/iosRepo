import SwiftUI
import FirebaseFirestore

struct NotificationView: View {
    @State private var pendingRides: [EmgCovoiturage] = []
    @State private var completedRides: [EmgCovoiturage] = []
    
    var body: some View {
        TabView {
            RideRequestsView(rides: $pendingRides)
                .tabItem {
                    Label("Pending Rides", systemImage: "clock")
                }
            
            CompletedRidesView(rides: $completedRides)
                .tabItem {
                    Label("Completed Rides", systemImage: "checkmark.circle")
                }
        }
        .onAppear {
            // Load data for pending and completed rides
            getRideRequests()
            getCompletedRides(type: "Emergency", id_cond: "65798eb63ed6f3fb203527e1")
        }
    }
    
    private func getRideRequests() {
        let db = Firestore.firestore()

        // Create a real-time listener for rideRequests filtered by driverId
        db.collection("rideRequests")
            .whereField("id_cond", isEqualTo: " ")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("No pending ride requests found for driverId: \("65798eb63ed6f3fb203527e1")")
                    return
                }

                print("Firestore Documents:", documents)

                pendingRides = documents.compactMap { (queryDocumentSnapshot) -> EmgCovoiturage? in
                    do {
                        var ride = try queryDocumentSnapshot.data(as: EmgCovoiturage.self)
                        
                        // Get the id field from the data
                        if let id = queryDocumentSnapshot.data()["id"] as? String {
                            ride.id = id
                        }
                        
                        return ride
                    } catch {
                        print("Error converting document:", error)
                        return nil
                    }
                }
            }
    }


    
    func getCompletedRides(type: String, id_cond: String) {
          // Construct the URL
          let urlString = "http://localhost:9090/covoiturage/ConducteurCovoiturage/\(type)/\(id_cond)"
          
          guard let url = URL(string: urlString) else {
              print("Invalid URL")
              return
          }
          
          // Create a URLSession task
          URLSession.shared.dataTask(with: url) { data, response, error in
              // Handle errors
              if let error = error {
                  print("Error fetching rides: \(error.localizedDescription)")
                  return
              }
              
              // Ensure we have data
              guard let data = data else {
                  print("No data received")
                  return
              }
              
              do {
                  // Decode the JSON data into an array of EmgCovoiturage
                  let decodedRides = try JSONDecoder().decode([EmgCovoiturage].self, from: data)
                  
                  // Update the published property on the main thread
                  DispatchQueue.main.async {
                      self.completedRides = decodedRides
                  }
                  
              } catch {
                  print("Error decoding JSON: \(error.localizedDescription)")
              }
              
          }.resume() // Start the task
      }
  }


struct RideRequestsView: View {
    @Binding var rides: [EmgCovoiturage]
    
    var body: some View {
        NavigationView {
            List(rides) { ride in
                DemandeRideCellView(ride: ride)
                
                    Button(action: {
                        updateRidA(Covoiturage:  ride.id ?? "659317d39a87b51cebcd46d5")
                        sendClientRequest(statut: "Accept",Client: ride.id_user! ,Covoiturage: ride.id!)
                    }) {
                        Text("Accept")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        updateRidR(Covoiturage:  ride.id ?? "659317d39a87b51cebcd46d5")
                        sendClientRequest(statut: "Refuse",Client: ride.id_user! ,Covoiturage: ride.id!)
                    }) {
                        Text("Decline")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            
            .navigationBarTitle("Pending Rides", displayMode: .inline)
            
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
                    print("Ride acecept status updated successfully!")
                    if let index = rides.firstIndex(where: { $0.id == Covoiturage }) {
                           rides.remove(at: index)
                       }
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
                    print("Ride refuse status updated successfully!")
                    if let index = rides.firstIndex(where: { $0.id == Covoiturage }) {
                           rides.remove(at: index)
                       }
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
    func sendClientRequest(statut: String,Client: String,Covoiturage:String) {
        let db = Firestore.firestore()

        // Create a new document in "rideRequests" collection
        db.collection("clientrequest").addDocument(data: [
            "status": statut,
            "client":Client,
                "covoiturage":Covoiturage
        ]) { err in
            if let err = err {
                print("Error sending ride request: \(err)")
            } else {
                print("Ride request sent successfully")
                // presentationMode.wrappedValue.dismiss() // Dismiss the view after sending the request
            }
        }
    }

}

struct CompletedRidesView: View {
    @Binding var rides: [EmgCovoiturage]
    
    var body: some View {
        NavigationView {
            List(rides) { ride in
                RideCellView(ride: ride)
            }
            .navigationBarTitle("Completed Rides", displayMode: .inline)
        }
    }
}
struct RideCellView: View {
    let ride: EmgCovoiturage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🚨 Emergency Ride")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.red)
                .padding(.bottom, 4) // Adding some bottom padding for separation
            
            Text("From: \(ride.pointDepart ?? "Unknown")")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
                .padding(.bottom, 2) // Adding slight bottom padding
            
            Text("To: \(ride.pointArrivee ?? "Unknown")")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
                .padding(.bottom, 2) // Adding slight bottom padding
            
            Text("Price: \(ride.Tarif ?? 0)€")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
                .padding(.bottom, 2) // Adding slight bottom padding
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


struct DemandeRideCellView: View{
    let ride: EmgCovoiturage
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
                  
                  
              }
              .padding()
              .background(Color.white)
              .onAppear {
                  print("riddeeee : ",ride)
                        
                              From = ride.pointDepart!
                              To = ride.pointArrivee!
                              Price = String(ride.Tarif!)
                  idCov = ride.id ?? "659317d39a87b51cebcd46d5"
                        
                  
              }
          }
        
    
    
}

// ... Your existing functions for updating ride status, fetching data, etc.

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
