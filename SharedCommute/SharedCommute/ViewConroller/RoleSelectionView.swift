//
//  RoleSelectionView.swift
//  SharedCommute
//
//  Created by rihemRD on 30/12/2023.
//

import SwiftUI
struct RoleSelectionView: View {
    @Binding var selectedRole: String?
    @Binding var isRoleSelectionPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Role")
                .font(.title)
                .padding()

            Button(action: {
                selectRole("driver")
            }) {
                RoleButton(role: "Driver", selected: selectedRole == "driver")
            }

            Button(action: {
                selectRole("client")
            }) {
                RoleButton(role: "Client", selected: selectedRole == "client")
            }

            Button(action: {
                selectRole("delivery man")
            }) {
                RoleButton(role: "Delivery Man", selected: selectedRole == "delivery man")
            }

            Spacer()

            Button(action: {
                confirmSelection()
            }) {
                Text("Select")
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func selectRole(_ role: String) {
        selectedRole = role
    }

    private func confirmSelection() {
  
        isRoleSelectionPresented = false
    }
}

struct RoleButton: View {
    let role: String
    let selected: Bool

    var body: some View {
        Text(role)
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(selected ? Color.green : Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}
