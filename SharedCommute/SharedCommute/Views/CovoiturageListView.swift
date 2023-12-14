//
//  CovoiturageListView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 8/12/2023.
//

import SwiftUI

struct CovoiturageListView: View {
    @State private var covoiturages: [Covoiturage] = []
    @State private var isShowingDeleteAlert = false
    @State private var selectedCovoiturage: Covoiturage?

    
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
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: MappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant("")).navigationBarBackButtonHidden(true)
                        .navigationBarBackButtonHidden(true)) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                
                List {
                    ForEach(covoiturages) { covoiturage in
                        if let reverseDate = reverseFormattedDate(dateString: covoiturage.dateCovoiturage) {
                            NavigationLink(
                                destination: MappingView(
                                    internalsource: .constant(covoiturage.pointDepart),
                                    internaldestination: .constant(covoiturage.pointArrivee),
                                    selectedHoursMapping: .constant(reverseDate.hour),
                                    selectedMinutesMapping: .constant(reverseDate.minute),
                                    initialidcovoiturage: .constant(covoiturage.id!)
                                )
                                .navigationBarHidden(true)
                            ) {
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
                                        Text("Date: \(covoiturage.dateCovoiturage)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedCovoiturage = covoiturage
                                                isShowingDeleteAlert = true
                                            }
                                        }
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
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Carpooling")
                .background(Color.blue.opacity(0.1))
                .alert(isPresented: $isShowingDeleteAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this Covoiturage?"),
                        primaryButton: .destructive(Text("Delete")) {
                            withAnimation {
                                if let selectedCovoiturage = selectedCovoiturage {
                                    deleteCovoiturage(covoiturage: selectedCovoiturage)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .onAppear {
                    fetchCovoiturages()
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
        }
    }


      private func deleteCovoiturage(covoiturage: Covoiturage) {
          // Make a delete request to your server
          let deleteURL = URL(string: "http://localhost:9090/covoiturage/delete/\(covoiturage.id!)")!
          
          var request = URLRequest(url: deleteURL)
          request.httpMethod = "DELETE"
          
          URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                  do {
                      // Check if the response indicates success
                      let successResponse = try JSONDecoder().decode([String: String].self, from: data)
                      if let message = successResponse["message"] {
                          print(message)
                          fetchCovoiturages()
                          // Update the local array to trigger view refresh
                          DispatchQueue.main.async {
                              covoiturages.removeAll { $0.id == covoiturage.id }
                          }
                      }
                  } catch {
                      print("Error decoding JSON: \(error)")
                  }
              } else if let error = error {
                  print("Error deleting data: \(error)")
              }
          }.resume()
      }
    private func fetchCovoiturages() {
            // Example URL:
            let findAllCovoituragesURL = URL(string: "http://localhost:9090/moyenDeTransport/findAllCovoiturages/2")!

            URLSession.shared.dataTask(with: findAllCovoituragesURL) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let covoituragesData = try decoder.decode([Covoiturage].self, from: data)

                        DispatchQueue.main.async {
                                              // Update the @State property to trigger view refresh
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


struct CovoiturageListViewpreview: PreviewProvider {
    static var previews: some View {
        CovoiturageListView()
    }
}
