//
//  NotificationView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 16) {
                    Image("siren")
                        .resizable()
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Emergency Ride")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Do you accept this ride?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("From: Your Start Point")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text("To: Your End Point")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Button(action: {}) {
                        Text("Accept")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Text("Decline")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.white)
        }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
