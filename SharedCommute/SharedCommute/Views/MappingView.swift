//
//  MappingView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 28/11/2023.
//

import SwiftUI

struct MappingView: View {
    @State private var source: String = ""
    @State private var destination: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .trailing) {
                       TextField("Source", text: $source)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                       
               
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
            
            Spacer()
            
                .padding()
        }
    }
}

struct MappingView_Previews: PreviewProvider {
    static var previews: some View {
        MappingView()
    }
}
