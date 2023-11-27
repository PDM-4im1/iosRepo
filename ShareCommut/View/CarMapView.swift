//
//  CarMapView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI

struct CarMapView: View {
    var body: some View {
        ZStack {
                   VStack {
                       
                       VStack {
                           HStack {
                               Image("ic_placeholder")
                                   .resizable()
                                   .frame(width: 33, height: 33)
                                   .background(Color.clear)
                               
                               TextField("your location", text: .constant(""))
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                           }
                           .padding()
                           
                           HStack {
                               Image("ic_search")
                                   .resizable()
                                   .frame(width: 33, height: 33)
                               
                               Text("Where to go ?")
                                   .frame(maxWidth: .infinity, alignment: .leading)
                                   .background(Color.clear)
                           }
                           .padding()
                           
                           HStack {
                               ImageButton(imageName: "ic_hospital")
                               ImageButton(imageName: "ic_police")
                               ImageButton(imageName: "ic_pharmacy")
                               ImageButton(imageName: "ic_doctor")
                           }
                           .padding()
                       }
                       .frame(height: 258)
                       .background(LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
                       )
                       .cornerRadius(20)
                       // MapView
                       MapView()
                           .ignoresSafeArea()
                       HStack {
                           Text("Duration")
                               .foregroundColor(.red)
                               .padding()
                               .hidden()
                            
                           
                           Text("Price")
                               .hidden()
                       }
                       
                       Button(action: {}) {
                        Text("Ride")
                        .foregroundColor(.white)
                        .padding()
                .background(Color.green)
                .cornerRadius(8)
                 .padding(.trailing, 11)
                                           }
                   }
               }
               .navigationBarHidden(true)
               .statusBar(hidden: true)
           }
    }
struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        // Replace with your MapView implementation
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the MapView if needed
    }
}
struct ImageButton: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
        }
        .frame(width: 70, height: 80)
    }
}

struct CarMapView_Previews: PreviewProvider {
    static var previews: some View {
        CarMapView()
    }
}
