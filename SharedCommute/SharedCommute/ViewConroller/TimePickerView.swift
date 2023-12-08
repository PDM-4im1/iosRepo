//
//  TimePickerView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 7/12/2023.
//
import SwiftUI
struct TimePickerView: View {
    @Binding  var selectedHour: Int
    @Binding  var selectedMinute: Int
    @Binding var source: String
    @Binding var destination: String
    @Binding var idcovoiturage : String
    @State private var isNavigationActive = false
    @State private var showAlert: Bool = false
        @State private var alertText: String = ""
        @State private var isShowingPicker: Bool = false

    func formattedDate(date: Date) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Customize the date format as per your needs
          return dateFormatter.string(from: date)
      }
    private func saveTrip() {
           // Convert selectedHourMapping and selectedMinuteMapping to a Date object
           let currentDate = Date()
           let calendar = Calendar.current
           var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
           dateComponents.hour = selectedHour
           dateComponents.minute = selectedMinute

        guard let tripDate = calendar.date(from: dateComponents) else {
               print("Error creating date from components.")
               return
           }
          let Stringdate = formattedDate(date: tripDate)
           // Your API call to save the trip
           saveTripToBackend(source: source, destination: destination, dateCovoiturage: Stringdate)
       }
    private func saveTripToBackend(source: String, destination: String, dateCovoiturage: String) {
        print(dateCovoiturage)
        // Create a Covoiturage object
        let covoiturage = Covoiturage(
            id: nil,

            id_cond: "1", // Update with the appropriate value
            id_user: "2", // Update with the appropriate value
            pointDepart: source,
            pointArrivee: destination,
            dateCovoiturage: dateCovoiturage,
            Tarif: 0 // Update with the appropriate value
        )

        // Convert Covoiturage object to JSON
        let jsonEncoder = JSONEncoder()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set your desired date format
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)

        guard let jsonData = try? jsonEncoder.encode(covoiturage) else {
            print("Error encoding Covoiturage object to JSON.")
            return
        }

        // Example URL:
        let saveTripURL = URL(string: "http://localhost:9090/covoiturage/saveCovoiturage")!

        var request = URLRequest(url: saveTripURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response from the backend
            if let data = data {
                // Parse the response data if needed
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("Response: \(responseString)")

                // Show success alert
                DispatchQueue.main.async {
                    showAlert(message: "Covoiturage saved successfully!")
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                // Show error alert if needed
            }
        }.resume()
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                // Handle OK action if needed
            }
        ))

        // Present the alert
        UIApplication.shared.windows.first?.rootViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
    private func editTrip() {
        // Convert selectedHourMapping and selectedMinuteMapping to a Date object
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        dateComponents.hour = selectedHour
        dateComponents.minute = selectedMinute

        guard let tripDate = calendar.date(from: dateComponents) else {
            print("Error creating date from components.")
            return
        }
        let Stringdate = formattedDate(date: tripDate)

        // Your API call to edit the trip
        editTripToBackend(source: source, destination: destination, dateCovoiturage: Stringdate)
    }
    private func editTripToBackend(source: String, destination: String, dateCovoiturage: String) {
        // Replace "tripId" with the actual ID of the trip you want to edit
        let tripId = idcovoiturage// Replace with the actual ID

        // Update the URL with the appropriate edit endpoint
        let editTripURL = URL(string: "http://localhost:9090/covoiturage/editCovoiturage/\(tripId)")!

        // Create a Covoiturage object with updated data
        let updatedCovoiturage = Covoiturage(
            id: nil,
            id_cond: "1", // Update with the appropriate value
            id_user: "2", // Update with the appropriate value
            pointDepart: source,
            pointArrivee: destination,
            dateCovoiturage: dateCovoiturage,
            Tarif: 0 // Update with the appropriate value
        )

        // Convert Covoiturage object to JSON
        let jsonEncoder = JSONEncoder()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set your desired date format
        jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)

        guard let jsonData = try? jsonEncoder.encode(updatedCovoiturage) else {
            print("Error encoding Covoiturage object to JSON.")
            return
        }

        // Create the URLRequest
        var request = URLRequest(url: editTripURL)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Perform the URL request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response from the backend
            if let data = data {
                // Parse the response data if needed
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("Response: \(responseString)")

                // Show success alert
                DispatchQueue.main.async {
                    showAlert(message: "Covoiturage updated successfully!")
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                // Show error alert if needed
            }
        }.resume()
    }



    var body: some View {
        
        VStack {
            Text("Pick a time for your trip")
                .font(.title)
                .padding(.bottom, 16)

            HStack(alignment: .center) {
                VStack {
                    Text("Hours")
                        .font(.headline)
                        .padding(.bottom, 8)

                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<24) { hour in
                            Text(String(format: "%02d", hour))
                                .font(.title)
                                .tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)
                    .clipped()
                }

                Text(":")
                    .font(.title)
                    .padding(.horizontal, 8)

                VStack {
                    Text("Minutes")
                        .font(.headline)
                        .padding(.bottom, 8)

                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute))
                                .font(.title)
                                .tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)
                    .clipped()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
           
            
            NavigationLink(
                              destination: CovoiturageListView(),
                              isActive: $isShowingPicker
                          ) {
                              EmptyView()
                          }
                          .hidden()

                          Button(action: {
                              if idcovoiturage.isEmpty {
                                  saveTrip()
                              } else {
                                  editTrip()
                              }

                              isShowingPicker = true

                          }) {
                              Text("Set Time")
                                  .font(.headline)
                                  .foregroundColor(.white)
                                  .padding(.vertical, 12)
                                  .padding(.horizontal, 24)
                                  .background(Color.blue)
                                  .cornerRadius(8)
                          }
                          .padding(.top, 16)
                      }
                      .padding()
                      .background(Color.gray.opacity(0.1))
                      .cornerRadius(16)
                      .padding(16)
                      .alert(isPresented: $showAlert) {
                          Alert(title: Text("Success"), message: Text(alertText), dismissButton: .default(Text("OK")))
                      }
                      // Hide the navigation bar
                      .navigationBarHidden(true)
                  }
              }
    
