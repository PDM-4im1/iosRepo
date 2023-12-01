//
//  PaymentView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//

import SwiftUI

struct PaymentView: View {
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
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        
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
