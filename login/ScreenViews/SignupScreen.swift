//
//  SignupScreen.swift
//  login
//
//  Created by Apple Esprit on 29/11/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct SignupScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var Cpassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var name: String = ""
    @State private var fname: String = ""
    @State private var age: String = ""
    @State private var role: String = ""
    @ObservedObject var signUpViewModel:SignUpViewModel
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack {
                    
                    
                    VStack {
                        HStack{
                            Text("Sign")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 30)
                            Text("Up")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 30)
                                .foregroundColor(Color("PrimaryColor"))
                        }
                        VStack{
                            TextField(" email address", text: $email)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            
                            SecureField("password", text:$password)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            SecureField("Confirm password", text:$Cpassword)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            
                            TextField(" phone number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            
                            TextField("name", text: $name)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            
                            TextField(" first name", text: $fname)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            TextField("age", text: $age)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                .padding(.vertical)
                            
                        }.padding(.horizontal,20)
                        
                        TextField("role", text: $role)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                            .padding(.vertical)
                            .padding(.horizontal,20)
                    
                    }
                        
                        
    
                        
                        NavigationLink(
                            destination: SignInScreenView(signInViewModel: SignInViewModel()).navigationBarHidden(true),
                          label: {
                            PrimaryButton(title: "Sign Up")
                          })
                        
                    }
                    
                    Spacer()
                    Divider()
                    Spacer()
                    Spacer(minLength: 20.0)
                    Text("You are completely safe.")
                    Text("Read our Terms & Conditions.")
                        .foregroundColor(Color("PrimaryColor"))
                    Spacer()
                    
                }
                .padding()
            }}
    }



@available(iOS 15.0, *)
struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen(signUpViewModel: SignUpViewModel())
    }
}
