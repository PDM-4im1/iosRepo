//
//  SearchView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 6/12/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject var locationManager: LocationManager = .init()
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 15){
                    Button{
                        
                    }label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    Text("search Location")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
               
                .frame(maxWidth: .infinity,alignment: .leading)
                HStack(spacing: 10){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Find location here", text: $locationManager.searchText)
                
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                .padding(.vertical,10)
                
                //live locaton btn
                if let places = locationManager.fetchedPlaces,places.isEmpty{
                    List{
                        ForEach(places,id: \.self){place in
                            HStack(spacing: 15){
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading,spacing:6){
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                else{
                    Button{
                        
                    }label: {
                        Label{
                            Text("Use Current Location")
                            .font(.callout)
                            
                        }icon: {
                            Image(systemName: "location.north.circle.fill")
                        }
                        .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
            .padding()
            .frame(maxHeight: .infinity,alignment : .top)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
