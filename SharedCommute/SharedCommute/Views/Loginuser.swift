
//
//  HomeView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 26/12/2023.
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPassword = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToHome = false
    @State private var navigateToHomeClient = false
    @State private var navigateToHomeDelivery = false
    var body: some View {
        NavigationView{
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 270, height: 300)
                .padding(.bottom, 10)

            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 50)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 50)
                .padding(.bottom, 30)

            Button(action: {
                login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            Button(action: {
                showForgotPassword.toggle()
            }) {
                Text("Forgot Password?")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 10)

            Spacer()

            HStack {
                Text("Don't have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                NavigationLink(destination: (SignUpView()).navigationBarBackButtonHidden(true)) {
                    Text("Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 30)
        }
        .padding(.top, 100)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showForgotPassword) {
            // Present the forgot password screen
            //ForgotPasswordView()
        }
        .background(
            NavigationLink(
                destination:( HomeView()).navigationBarBackButtonHidden(true), // Replace with your home screen
                isActive: $navigateToHome,
                label: { EmptyView() }
            ))
        .background(
            NavigationLink(
                destination:( ClientHomeView()).navigationBarBackButtonHidden(true), // Replace with your home screen
                isActive: $navigateToHomeClient,
                label: { EmptyView() }
            ))
        .background(
            NavigationLink(
                destination:( DeliverytHomeView()).navigationBarBackButtonHidden(true), // Replace with your home screen
                isActive: $navigateToHomeDelivery,
                label: { EmptyView() }
            ))
    
    }
    }

    func login() {
        if !isValidEmail(email) {
                  errorMessage = "Please enter a valid email address"
                  showError = true
                  return
              }
        let url = URL(string: "http://localhost:9090/user/signin")! // Replace with your actual server URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    errorMessage = "An error occurred. Please try again."
                    showError = true
                    return
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: data)

                        // Login successful, 'user' now contains the decoded user data
                        print("Logged in as \(user.name)")
                        
                        // Store user ID in UserDefaults
                        UserDefaults.standard.set(user.id, forKey: "userID")

                        if(user.role == "client"){
                        navigateToHomeClient = true

                    }
                        if(user.role == "driver"){
                        navigateToHome = true

                    }
                        if(user.role == "delivery man"){
                        navigateToHomeDelivery = true

                    }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        errorMessage = "An error occurred. Please try again."
                        showError = true
                    }
                }
            }
        }.resume()
    }
    }
func isValidEmail(_ email: String) -> Bool {
       let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
       return emailPredicate.evaluate(with: email)
   }
   

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
