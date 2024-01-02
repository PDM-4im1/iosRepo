//
//  UserCreateColisView.swift
//  SharedCommute
//
//  Created by nasrimootez on 2/1/2024.
//

import SwiftUI

struct UserCreateColisView: View {
    @State private var width = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var description = ""

    @State private var isWidthValid = true
    @State private var isHeightValid = true
    @State private var isWeightValid = true
    @State private var isDescriptionValid = true
    
    @State private var shouldNavigate = false
    @StateObject var viewModel = ColisModelViewModel()
    @State private var isSnackbarVisible = false

    var isFormValid: Bool {
        return !width.isEmpty && !height.isEmpty && !weight.isEmpty && !description.isEmpty &&
            isWidthValid && isHeightValid && isWeightValid && isDescriptionValid
    }

    var body: some View {
        NavigationView {
            VStack {
                createValidatedTextField(systemName: "arrow.left.and.right.circle.fill", placeholder: "Width in Inches", text: $width, isValid: $isWidthValid, validator: .number, errorMessage: "Please enter a valid width (numeric)")
                createValidatedTextField(systemName: "arrow.up.and.down.circle.fill", placeholder: "Height in Inches", text: $height, isValid: $isHeightValid, validator: .number, errorMessage: "Please enter a valid height (numeric)")
                createValidatedTextField(systemName: "scalemass.fill", placeholder: "Weight in Inches", text: $weight, isValid: $isWeightValid, validator: .number, errorMessage: "Please enter a valid weight (numeric)")
                createValidatedTextField(systemName: "doc.text", placeholder: "Description", text: $description, isValid: $isDescriptionValid, validator: .letters, errorMessage: "Please enter a valid description (letters only)")

                Button(action: {
                    if isFormValid {
                        shouldNavigate = true
                    }
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
             
                .disabled(!isFormValid)
                .background(
                    NavigationLink(destination: HomeViewDelivery(width: width, height: height, weight: weight, description: description), isActive: $shouldNavigate) { EmptyView() }
                )

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            Spacer()
                .navigationTitle("Create Colis")
                .padding()
        }
    }
    

    enum Validator {
        case number
        case letters
        case phone
    }

    func createValidatedTextField(systemName: String, placeholder: String, text: Binding<String>, isValid: Binding<Bool>, validator: Validator, errorMessage: String) -> some View {
        VStack {
            HStack {
                Image(systemName: systemName)
                    .foregroundColor(.blue)
                TextField(placeholder, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: text.wrappedValue) { newValue in
                        switch validator {
                        case .number:
                            isValid.wrappedValue = newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
                        case .letters:
                            isValid.wrappedValue = newValue.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
                        case .phone:
                            isValid.wrappedValue = newValue.count == 8 && newValue.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
                        }
                    }
            }
            if !isValid.wrappedValue {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding()
    }
}

struct UserCreateColisView_Previews: PreviewProvider {
    static var previews: some View {
        UserCreateColisView()
        
        
    }
}
