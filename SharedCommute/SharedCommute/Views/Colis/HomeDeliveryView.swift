//
//  HomeView.swift
//  project
//
//  Created by Apple Esprit on 27/11/2023.
//

import SwiftUI

struct HomeViewDelivery: View {
    @State private var mapState = MapViewState.noInput
    let width : String
    let height : String
    let weight : String
    let description : String
    @EnvironmentObject var locationViewModel:
    LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top){
                MapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }
                else if mapState == .noInput{
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()){
                                mapState = .searchingForLocation
                            }
                            
                                    }
                }
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
          if mapState == .locationSelected{
                DeliveryRequestView(width: width, height: height, weight: weight, description: description)
                  .transition(.move(edge: .bottom))
            }
        }
        .environmentObject(locationViewModel)
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation){
            location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
        
    }
}





