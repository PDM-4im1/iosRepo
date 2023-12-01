//
//  EmgDriverCell.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI

struct EmgDriverCell: View {
    let driver: Driver
    @State private var showPaymentView = false
    var body: some View {
        VStack {
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
                    HStack {
                                       Image(systemName: "dollarsign.circle")
                                       Text("7.500 DT")
                                   }
                                   .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                
                
               
            }
            
            Button(action: {
                showPaymentView = true
            }) {
                Text("Confirm")
                    .foregroundColor(.white)
            }
            .frame(height: 35)
            .background(Color.green)
            .cornerRadius(5)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .sheet(isPresented: $showPaymentView) {
                PaymentSelectionView()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

 

