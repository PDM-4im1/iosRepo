//
// ResetPass.swift
// login
//
// Created by Mac Mini on 30/11/2023.
//

import SwiftUI



@available(iOS 15.0, *)
struct ResetPass: View {
  @State private var newPassword: String = ""
  @State private var confirmPassword: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var shouldNavigateToSignIn: Bool = false

   
  var body: some View {
    ZStack {
      Color("BgColor").edgesIgnoringSafeArea(.all)
       
      VStack {
        Text("Reset Password")
          .font(.system(size: 30, weight: .bold))
          .padding()
         
        SecureField("New password", text: $newPassword)
          .font(.title3)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.white)
          .cornerRadius(50.0)
          .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
          .padding(.vertical)
         
        SecureField("Confirm password", text: $confirmPassword)
          .font(.title3)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.white)
          .cornerRadius(50.0)
          .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
          .padding(.vertical)
         
          NavigationLink(
            destination: SignInScreenView(signInViewModel: SignInViewModel()),
              isActive: $shouldNavigateToSignIn
          ) {
              EmptyView()
          }

          Button(action: {
              // Handle button press
              if $newPassword.wrappedValue.count < 6 {
                  print("Password must be at least 6 characters long")
                  return
              }

              if $newPassword.wrappedValue != $confirmPassword.wrappedValue {
                  print("Passwords do not match")
                  return
              }

              // Trigger navigation to SignInScreenView
              shouldNavigateToSignIn = true
          }) {
              PrimaryButton(title: "Reset Password")
                  .padding()
          }

          if $newPassword.wrappedValue.count < 6 {
              Text("Password must be at least 6 characters long")
                  .foregroundColor(.red)
                  .padding()
          }

          if $newPassword.wrappedValue != $confirmPassword.wrappedValue {
              Text("Passwords do not match")
                  .foregroundColor(.red)
                  .padding()
          }

         
        Spacer()
      }
      .padding()
    }
  }
   
  struct ResetPass_Previews: PreviewProvider {
    static var previews: some View {
      ResetPass()
    }
  }
}
