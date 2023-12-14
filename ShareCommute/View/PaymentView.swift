//
//  PaymentView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//

import SwiftUI
struct PaymentView: View {
    @State private var idUser = "656080221d51b314e6169893"
    var body: some View {
        VStack {
            Text("Payment Details")
                .font(.title)
                .bold()
                .padding(.top, 40)
            Text("Emergency Ride")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            
            
            
            Text("Price : 7.500 DT")
                .font(.headline)
                .foregroundColor(.black)
            Text("Conducteur : mansour")
                .font(.headline)
                .foregroundColor(.black)
            
            Image("credit_card")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 120)
            
            Spacer()
            
            
            VStack(alignment: .leading, spacing: 16) {
                PaymentTextField(iconName: "person.fill", placeholder: "Cardholder Name")
                PaymentTextField(iconName: "creditcard.fill", placeholder: "Card Number")
                HStack {
                    PaymentTextField(iconName: "calendar.fill", placeholder: "Expiration Date")
                    PaymentTextField(iconName: "lock.fill", placeholder: "CVV")
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {}) {
                Text("Pay Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            .onAppear {
                fetchUser(UserId: idUser) { user in
                    if let user = user {
                        DispatchQueue.main.async {
                            print(user)
                           // name = user.name + " " + user.firstName
                            //phone = user.phoneNumber
                        }
                    } else {
                        print("User not found")
                    }
                }
                
            }
        }
        
    }
    func fetchUser(UserId userId: String, completion: @escaping (User?) -> Void) {
        let urlString = "http://localhost:9090/covoiturage/findUser/\(userId)"
        
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
                    let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
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

struct PaymentTextField: View {
    var iconName: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .font(.system(size: 18))
            
            TextField(placeholder, text: .constant(""))
                .foregroundColor(.black)
                .font(.body)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
