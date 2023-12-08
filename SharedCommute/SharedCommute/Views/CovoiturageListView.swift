//
//  CovoiturageListView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 8/12/2023.
//

import SwiftUI

struct CovoiturageListView: View {
    @State private var covoiturages: [Covoiturage] = []
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
                 // Plus button to add a new trip
                 HStack {
                     Spacer()
                     NavigationLink(destination: MappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))) {
                         Image(systemName: "plus.circle")
                             .font(.title)
                             .foregroundColor(.blue)
                             .padding()
                     }
                 }

                 List(covoiturages) { covoiturage in
                     if let reverseDate = reverseFormattedDate(dateString: covoiturage.dateCovoiturage) {
                         NavigationLink(
                             destination: MappingView(
                                 internalsource: .constant(covoiturage.pointDepart),
                                 internaldestination: .constant(covoiturage.pointArrivee),
                                 selectedHoursMapping: .constant(reverseDate.hour),
                                 selectedMinutesMapping: .constant(reverseDate.minute),
                                 initialidcovoiturage: .constant(covoiturage.id!)
                             )    .navigationBarHidden(true)  // Hide
                         ) {
                             HStack(spacing: 16) {
                                 Image(systemName: "car.fill") // Placeholder car image, replace with actual carpooling image
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(width: 40, height: 40)
                                     .foregroundColor(.blue)

                                 VStack(alignment: .leading, spacing: 8) {
                                     Text("Departure: \(covoiturage.pointDepart)")
                                         .font(.headline)
                                     Text("Destination: \(covoiturage.pointArrivee)")
                                         .font(.subheadline)
                                     Text("Date: \(covoiturage.dateCovoiturage)")
                                         .font(.subheadline)
                                 }
                             }
                             .padding()
                             .background(Color.white)
                             .cornerRadius(10)
                             .shadow(radius: 3)
                         }
                     }
                 }
                 .listStyle(PlainListStyle())
                 .navigationBarTitle("Carpooling")
                

                 .onAppear {
                     fetchCovoiturages()
                 }
                 Spacer()
             }
             .padding()
         }
     }
    private func fetchCovoiturages() {
        // Example URL:
        let findAllCovoituragesURL = URL(string: "http://localhost:9090/moyenDeTransport/findAllCovoiturages/2")!

        URLSession.shared.dataTask(with: findAllCovoituragesURL) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    var covoituragesData = try decoder.decode([Covoiturage].self, from: data)

                 
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
 
    }   }

struct CovoiturageListViewpreview: PreviewProvider {
    static var previews: some View {
        CovoiturageListView()
    }
}
