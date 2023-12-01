//
//  PaymentSelectionView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//

import SwiftUI

struct PaymentSelectionView: View {
    let driver =
        Driver(name: "Driver 1",phone: "22 555 888", car: "cito")
        
    @State private var showPaymentView = false
    @State private var paymentMethod = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 55, height: 58)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person")
                        Text(driver.name)
                    }
                    
                    HStack {
                        Image(systemName: "phone")
                        Text(driver.phone)
                    }
                    
                    HStack {
                        Image(systemName: "car")
                        Text(driver.car)
                    }
                }
            }
            
            HStack {
                Image(systemName: "dollarsign.circle")
                Text("7.500 DT")
            }
            
            Picker(selection: $paymentMethod, label: Text("Payment Method")) {
                Text("Online").tag(0)
                Text("Cash").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                           if paymentMethod == 0 {
                               showPaymentView = true
                           } else {
                               // Show success view or perform success action
                           }
                       }) {
                           Text("Confirm")
                               .foregroundColor(.white)
                       }
                       .frame(height: 43)
                       .background(Color.green)
                       .cornerRadius(5)
                       .sheet(isPresented: $showPaymentView) {
                           PaymentView()
                       }
            
            Spacer()
        }
        .padding()
    }
}

struct PaymentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSelectionView()
    }
}
