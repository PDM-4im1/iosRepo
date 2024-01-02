//
//  LivreurColisView.swift
//  project
//
//  Created by Apple Esprit on 8/12/2023.
//

import SwiftUI

struct LivreurColisView: View {
    @ObservedObject var viewModel: ColisModelViewModel
    @State private var selectedView: ColisViewState = .livreur

    let statusOptions = ["non Livree", "en route", "livree"]
    @State private var refreshView = UUID()

    var body: some View {
        NavigationView {
           
                if !viewModel.colisList.isEmpty {
                    List {
                        ForEach(viewModel.colisList) { colis in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("#\(colis.id)")
                                        .font(.headline)
                                    Text("\(colis.description)")
                                        .font(.subheadline)
                                    // Add more details as needed
                                }
                                Spacer()
                                
                                Picker("", selection: Binding(
                                    get: { colis.etat },
                                    set: { newValue in
                                        let idString = String(colis.id)
                                        viewModel.changeEtatColis(id: idString, etat: newValue)
                                    }
                                )) {
                                    ForEach(statusOptions, id: \.self) { status in
                                        Text(status).tag(status)
                                    }
                                }
                                .id(refreshView)
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 100)
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                } else {
Text("no list presented")               }
            
            
        }
        .navigationTitle("Livreur Colis")
        .onAppear {
            DispatchQueue.main.async {
                
                
                if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                    viewModel.getLivreurColis(livreurId: userID)
                    print("User ID: \(userID)")
                } else {
                    print("User ID not found in UserDefaults.")
                }}
            
        }
    }
}






