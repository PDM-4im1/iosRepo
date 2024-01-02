import SwiftUI

struct UnassignedColisView: View {
    @StateObject var viewModel = ColisModelViewModel()
    @State private var selectedView: ColisViewState = .unassigned

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select View", selection: $selectedView) {
                    Text("Unassigned").tag(ColisViewState.unassigned)
                    Text("Livreur").tag(ColisViewState.livreur)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                
                if selectedView == .unassigned {
                  
                    UnassignedContentView(viewModel: viewModel)
                        .onAppear {
                            viewModel.fetchUnassignedColis()
                        }
                } else {
                    LivreurColisView(viewModel: viewModel)
                }
            }
            .navigationTitle(selectedView == .unassigned ? "Unassigned Colis" : "Livreur Colis")
        }
    }
}
struct UnassignedContentView: View {
    @ObservedObject var viewModel: ColisModelViewModel
    @State private var userid : String = ""

    var body: some View {
        // Your existing UnassignedColisView content here
        VStack {
                       if !viewModel.colisList.isEmpty {
                           List {
                               ForEach(viewModel.colisList.indices, id: \.self) { index in
                                   let colis = viewModel.colisList[index]
                                   if colis.idLivreur == "" {
                                       HStack {
                                           VStack(alignment: .leading, spacing: 8) {
                                               Text("ID: \(colis.id)")
                                                   .font(.headline)
                                               Text("Description: \(colis.description)")
                                                   .font(.subheadline)
                                               // Add more Text views to display other Colis details as needed
                                           }
                                           Spacer()
                                           Button(action: {
                                               let colisIDString = String(colis.id)
                                               viewModel.assignLivreur(id: colisIDString, idLivreur: userid)
                                               viewModel.colisList.remove(at: index) // Remove assigned colis
                                           }) {
                                               HStack {
                                                   Text("Assign")
                                                   Image(systemName: "arrow.right.circle.fill")
                                               }
                                               .foregroundColor(.white)
                                               .padding(.horizontal, 12)
                                               .padding(.vertical, 6)
                                               .background(Color.blue)
                                               .cornerRadius(8)
                                           }
                                       }
                                       .padding(8)
                                       .background(Color(UIColor.systemBackground))
                                       .cornerRadius(8)
                                       .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                   }
                               }
                           }
                           .listStyle(PlainListStyle())
                       } else {
                           if !viewModel.errorMessage.isEmpty {
                               Text(viewModel.errorMessage)
                                   .foregroundColor(.red)
                                   .padding()
                           } else {
                               ProgressView()
                                   .onAppear {
                                       viewModel.fetchUnassignedColis()
                                   }
                           }
                       }
        }.onAppear{  if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
            userid = userID
            print("User ID: \(userID)")
        } else {
            print("User ID not found in UserDefaults.")
        }}
    }
}
