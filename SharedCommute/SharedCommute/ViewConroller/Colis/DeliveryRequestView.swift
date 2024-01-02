//
//  DeliveryRequestView.swift
//  project
//
//  Created by Apple Esprit on 28/11/2023.
//

import SwiftUI

struct DeliveryRequestView: View {
    @State private var isSnackbarVisible = false
    @State private var shouldNavigate = false
    @StateObject var viewModel = ColisModelViewModel()
    @State private var selectedDeliveryType: DeliveryType = .express
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @State private var receiverName = ""
    @State private var receiverPhone = ""
    @State private var destination = ""
    @State private var idClient = ""
    @State private var isReceiverNameValid = true
    @State private var isReceiverPhoneValid = true
    
    let width : String
    let height : String
    let weight : String
    let description : String
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            HStack{
                /*VStack{
                 Circle()
                 .fill(Color(.systemGray3))
                 .frame(width: 8, height: 8)
                 Rectangle()
                 .fill(Color(.systemGray3))
                 .frame(width: 1, height: 24)
                 Rectangle()
                 .fill(.black)
                 .frame(width: 8, height: 8)
                 
                 }*/
                VStack(alignment: .leading, spacing: 24 ) {
                    
                    createValidatedTextField(systemName: "person", placeholder: "Receiver Name", text: $receiverName, isValid: $isReceiverNameValid, validator: .letters, errorMessage: "Please enter a valid receiver name (letters only)")
                    
                    createValidatedTextField(systemName: "phone", placeholder: "Receiver Phone", text: $receiverPhone, isValid: $isReceiverPhoneValid, validator: .phone, errorMessage: "Please enter a valid 8-digit phone number")
                    
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            Divider()
            
            Text("DELIVERY TYPES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal){
                HStack(spacing: 45 ){
                    ForEach(DeliveryType.allCases){ type in
                        VStack(alignment: .leading){
                            Image(type.imaageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(type.description)
                                    .font(.system(size: 14, weight: .semibold))
                                Text("$\(locationViewModel.computeDeliveryPrice(forType: type))")
                                    .font(.system(size: 14, weight: .semibold))
                                
                            }
                            .padding(1)
                            
                            
                        }
                        
                        .frame(width: 112,height: 148)
                        .foregroundColor(type == selectedDeliveryType ? .white : .black)
                        .background(Color(type == selectedDeliveryType ?
                            .systemBlue :
                                .systemGroupedBackground))
                        .scaleEffect(type == selectedDeliveryType
                                     ? 1.25 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()){
                                selectedDeliveryType = type
                            }
                        }
                        
                        
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            /* HStack(spacing: 12){
             Text("Visa")
             .font(.subheadline)
             .fontWeight(.semibold)
             .padding(6)
             .background(.blue)
             .cornerRadius(4)
             .foregroundColor(.white)
             .padding(.leading)
             
             Text("**** 1234")
             .fontWeight(.bold)
             
             Spacer()
             
             Image(systemName: "chevron.right")
             .padding()
             
             
             }*/
                .frame(height: 50)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button{
                if let selectedCoordinate = locationViewModel.selectedLocationCoordinate {
                                    locationViewModel.getAddress(from: selectedCoordinate) { address in
                                        if let address = address {
                                            self.destination = address
                                            
            print(destination)
                                            
                viewModel.createColis(
                    width: Int(width) ?? 0,
                    weight: Int(weight) ?? 0,
                    height: Int(height) ?? 0,
                    description: description,
                    adresse: "esprit",
                    destination: destination,
                    receiverName: receiverName,
                    receiverPhone: receiverPhone,
                    idClient : idClient
                )
                isSnackbarVisible = true
            }
        }
    }
                
                
            } label: {
                Text("CONFIRM DELIVERY")
                
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32 , height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .alert(isPresented: $isSnackbarVisible) {
                                Alert(title: Text("Colis added successfully"), dismissButton: .default(
                                    Text("OK"),
                                    action: {
                                shouldNavigate = true
                                                                }))
                                        
                            }
            .background(
                                NavigationLink(destination: ColisView(), isActive: $shouldNavigate) { EmptyView() }
                            )
            
        }.onAppear{if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
            idClient = userID
            print("User ID: \(userID)")
        } else {
            print("User ID not found in UserDefaults.")
        }}
        .environmentObject(LocationSearchViewModel())
        .padding(.bottom,24)
        .background(.white)
        .cornerRadius(16)

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
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
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

/*struct DeliveryRequestView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryRequestView()
            .environmentObject(LocationSearchViewModel())
    }
}*/
