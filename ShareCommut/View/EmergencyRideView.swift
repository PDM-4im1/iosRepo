//
//  EmergencyRideView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI

struct EmergencyRideView: View {
   
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
               
                            
                            Text("Hi")
                                .font(.title)
                                .padding(.top, 40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Rihem")
                                .font(.headline)
                                .frame(maxWidth: 300, alignment: .leading)
                                .padding(.bottom, 4)
                            
                            Text("Do you need an emergency ride?")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 120)
                            
                            VStack {
                                Image("car")
                                    .resizable()
                                    .frame(width: 107, height: 85)
                                    .padding(.top, 20)
                                
                                VStack {
                                    Text("Emergency")
                                    
                                    Text("Car")
                                        .foregroundColor(.green)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            .background(Color(red: 219/255, green: 219/255, blue: 219/255))
                            .frame(width: 179, height: 170)
                            .padding(8)
                
            Spacer()
                Image("rectangle")
                                .resizable()
                               
                        }
                        .navigationBarHidden(true)
                        .padding(5)
                    }
            }
                
        }
    
struct EmergencyRideView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyRideView()
    }
}
