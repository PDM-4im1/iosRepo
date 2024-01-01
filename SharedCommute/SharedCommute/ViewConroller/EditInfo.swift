//
//  EditInfo.swift
//  SharedCommute
//
//  Created by nasrimootez on 1/1/2024.
//
import SwiftUI

struct EditInfoView: View {
    @State private var editedUser: MutableUser // Use a state variable for the edited user
    @State private var isPasswordVisible = false

    init(user: User) {
        // Initialize the state variable with a mutable version of the provided user
        _editedUser = State(initialValue: MutableUser(from: user))
    }

    var body: some View {
        VStack {
            Text("Edit Info Page")

            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Email", text: $editedUser.email)
                    TextField("Name", text: $editedUser.name)
                    TextField("First Name", text: $editedUser.firstName)
                    
                    Stepper("Age: \(editedUser.age)", value: $editedUser.age, in: 18...100)
                }

                Section(header: Text("Security")) {
                    ZStack(alignment: .trailing) {
                        if isPasswordVisible {
                            TextField("Password", text: $editedUser.password)
                              
                        } else {
                            SecureField("Password", text: $editedUser.password)
                            
                        }

                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 15)
                        }
                        .padding(.bottom, 30)
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                // Add more sections as needed

                Button("Save Changes") {
                    // Perform the action to save changes
                    saveChanges()
                }
            }
            .padding()
        }
    }

    func saveChanges() {
        // Implement the logic to save the edited user to your data store
        // You can access the edited user using editedUser
        let updatedUser = User(
            id: editedUser.id,
            email: editedUser.email,
            password: editedUser.password,
            phoneNumber: editedUser.phoneNumber,
            role: editedUser.role,
            name: editedUser.name,
            firstName: editedUser.firstName,
            age: editedUser.age
        )
        // Perform the necessary actions with the updated user
        print("Changes saved: \(updatedUser)")
    }
}
