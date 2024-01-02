//
//  ColisView.swift
//  SharedCommute
//
//  Created by nasrimootez on 2/1/2024.
//

import SwiftUI

struct ColisView: View {
    @StateObject var viewModel = ColisModelViewModel()
    @State private var colisID: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var etatMessage: String = ""
    @State private var colisResult: ColisModel? = nil // Store the retrieved ColisModel

    var body: some View {
        VStack {
            TextField("Enter Colis ID", text: $colisID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Get Colis") {
                viewModel.getColis(id: colisID) { result in
                    switch result {
                    case .success(let colis):
                        colisResult = colis // Update colisResult with the fetched ColisModel
                        showAlert = true
                        etatMessage = "Etat: \(colis.etat)"
                    case .failure(let error):
                        errorMessage = "Error fetching Colis: \(error.localizedDescription)"
                    }
                }
            }
            .padding()

            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
                .onReceive(viewModel.$errorMessage) { newErrorMessage in
                    errorMessage = newErrorMessage
                }
            
            if let colis = colisResult {
                ProgressBar(colisEtat: colis.etat)
                    .padding()
            }
        }
        
    }
}

struct ProgressBar: View {
    let colisEtat: String
    
    var body: some View {
        HStack(spacing: 0) {
            ProgressStageView(text: "non Livree", isActive: colisEtat == "non Livree")
            Spacer()
            ProgressStageView(text: "En route", isActive: colisEtat == "en route" )
            Spacer()
            ProgressStageView(text: "livree", isActive: colisEtat == "livree")
        }
        .padding()
    }
}

struct ProgressStageView: View {
    let text: String
    let isActive: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(isActive ? Color.blue : Color.gray)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.caption)
                .foregroundColor(isActive ? .blue : .gray)
        }
    }
}
