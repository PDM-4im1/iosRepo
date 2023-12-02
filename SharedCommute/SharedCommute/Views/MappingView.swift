//
//  MappingView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 28/11/2023.
//

import SwiftUI
import GoogleMaps


struct MappingView: View {
    @State private var source: String = ""
    @State private var destination: String = ""
    @State private var routes: [GMSPolyline] = []
    @State private var isButtonTapped: Bool = false

    
    var body: some View {
        
        VStack {
            Spacer()
            ZStack(alignment: .trailing) {
                TextField("Source", text: $source)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .id("sourceTextField")
                       
               
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.green)
                    .font(.title)
                           .foregroundColor(.blue)
                           .font(.title)
                          
                   }
            Spacer()
            Spacer()

            TextField("Destination", text: $destination)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .id("destinationTextField")
            
            Spacer()
            Spacer()

            Button(action: {
                isButtonTapped = true
            }) {
                Text("Confirm Direction")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            GoogleMapsView(source: $source, destination: $destination, routes: $routes,isButtonTapped:$isButtonTapped)
                        .edgesIgnoringSafeArea(.all)
                        .padding()
        }
    }
}

struct MappingView_Previews: PreviewProvider {
    static var previews: some View {
        MappingView()
    }
}
