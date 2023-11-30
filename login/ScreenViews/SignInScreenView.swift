//
//  SignInScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct SignInScreenView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var signInViewModel:SignInViewModel
    // by default it's empty
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack {
                    HStack{
                        Text("Sign")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        Text("In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple"))
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google").foregroundColor(Color("PrimaryColor")))
                        .padding(.vertical)
                    
                    Text("or get a link emailed to you")
                        .foregroundColor(Color.black.opacity(0.4))
                    
                    TextField(" email address", text: $signInViewModel.email)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    
                    SecureField("password", text:$signInViewModel.password)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    
                    
                    NavigationLink(
                        destination: ClientHome(),
                        label: {
                            PrimaryButton(title: "Sign In", action: {
                                signInViewModel.login()
                            })
                        }
                    )

                  /*  Button(action: {
                       
                        signInViewModel.login()
                     
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }*/
                    NavigationLink(
                      destination: ForgetPass().navigationBarHidden(true),
                      label: {
                          Text("forgot pasword ?")
                              .foregroundColor(Color.black.opacity(0.4))
                      })
                }
                
                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                Text("Read our Terms & Conditions.")
                    .foregroundColor(Color("PrimaryColor"))
                Spacer()
                
            }
            .padding()
        }
    }
}

@available(iOS 15.0, *)
struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView(signInViewModel: SignInViewModel()
        )
    }
}


struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
    }
}
