//
//  CovoiturageListView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 8/12/2023.
//

import SwiftUI
import UIKit

struct CovoiturageHistory: View {
    @State private var covoiturages: [Covoiturage] = []
    @State private var isShowingDeleteAlert = false
    @State private var selectedCovoiturage: Covoiturage?
    @State  private var iduser : String = ""
    
    private func reverseFormattedDate(dateString: String) -> (hour: Int, minute: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let date = dateFormatter.date(from: dateString) else {
            print("Error parsing date string.")
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else {
            print("Error extracting components from date.")
            return nil
        }

        return (hour, minute)
    }
    

    
    var body: some View {
            VStack {
               
                
                List {
                    
                                  if covoiturages.isEmpty {
                                      Text("No Carpoolings History Found.")
                                          .foregroundColor(.gray)
                                          .padding()
                                  }
                    ForEach(covoiturages) {  covoiturage in
                        if let reverseDate = reverseFormattedDate(dateString: covoiturage.dateCovoiturage ?? "") {
                           
                           
                                HStack {
                                  
                                    Image(systemName: "car.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Departure: \(covoiturage.pointDepart)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("Destination: \(covoiturage.pointArrivee)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Date: \(covoiturage.dateCovoiturage!)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                
                              
                                      
                                
                                }
                                
                            
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .animation(.easeInOut(duration: 0.3))
                            
                           
                            
                                
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.blue.opacity(0.1))
                
                .onAppear {
                    DispatchQueue.main.async {
                        fetchCovoiturages()
                    }                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                       // This block will be executed when the app enters the foreground
                       fetchCovoiturages()
                   }
              
                Spacer()
            }
            .padding()
            .background(Color.white)
        }
    


      
     func fetchCovoiturages() {
        if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
            iduser = userID
            print("User ID: \(userID)")
        } else {
            print("User ID not found in UserDefaults.")
        }

        let findAllCovoituragesURL = URL(string: "http://localhost:9090/moyenDeTransport/findAllCovoiturages/\(iduser)")!

        URLSession.shared.dataTask(with: findAllCovoituragesURL) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    
                    // Assuming your Covoiturage type has a CodingKeys enum, adapt as needed
                    let covoituragesData = try decoder.decode([Covoiturage].self, from: data)

                    // Assuming covoituragesData is an array of objects
                    DispatchQueue.main.async {
                        self.covoiturages = covoituragesData

                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    }

    


struct CovoiturageHomeViewpreview: PreviewProvider {
    static var previews: some View {
        CovoiturageHistory()
    }
}
