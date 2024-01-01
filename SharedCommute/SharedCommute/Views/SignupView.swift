//
//  HomeView.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 26/12/2023.

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var Name = ""
    @State private var firstName = ""
    @State private var age = ""

    @State private var isEmailPasswordValidated = false
    @State private var showError = false
    @State private var showSuccessAlert = false
    @State private var errorMessage = ""
    @State private var navigateToLogin   = false

    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var isRoleSelectionPresented = false
     @State private var selectedRole: String? = nil
    var body: some View {
        NavigationView {
      
            VStack{
                NavigationLink(
                    destination: (LoginView()).navigationBarBackButtonHidden(true),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                ).alert(isPresented: $showSuccessAlert) {
                    Alert(
                        title: Text("Success"),
                        message: Text("Sign up successful!"),
                        dismissButton: .default(Text("OK")) {
                            // Set the state to trigger navigation to the login view
                            navigateToLogin = true
                        }
                    )
                }

                if isEmailPasswordValidated {
                      HStack {
                          Button(action: {
                              withAnimation {
                                  isEmailPasswordValidated = false
                              }
                          }) {
                              Image(systemName: "chevron.left")
                              Text("Back")
                                  .foregroundColor(.blue)
                                  .font(.title2)
                          }
                          .transition(.move(edge: .top))
                          .padding(.top, 20)
                          Spacer()
                      }
                  }

                Image("logo")
                    .resizable()
                    .frame(width: 170, height: 200)
                Text("Sign Up")
                    .font(.title)
                Spacer(minLength: 20)
                VStack(alignment: .leading, spacing: 10) {
                    if !isEmailPasswordValidated {
                        Text("Email")
                            .font(.headline)
                            .opacity(1)

                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .textContentType(.emailAddress)
                            .opacity(1)

                        Text("Password")
                                       .font(.headline)
                                       .opacity(1)

                                   ZStack(alignment: .trailing) {
                                       if isPasswordVisible {
                                           TextField("Password", text: $password)
                                               .padding()
                                               .background(Color.gray.opacity(0.2))
                                               .cornerRadius(10)
                                               .padding(.horizontal, 20)
                                               .textContentType(.password)
                                               .opacity(1)
                                       } else {
                                           SecureField("Password", text: $password)
                                               .padding()
                                               .background(Color.gray.opacity(0.2))
                                               .cornerRadius(10)
                                               .padding(.horizontal, 20)
                                               .textContentType(.password)
                                               .opacity(1)
                                       }

                                       Button(action: {
                                           isPasswordVisible.toggle()
                                       }) {
                                           Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                               .foregroundColor(.gray)
                                               .padding(.trailing, 25)
                                       }
                                       .buttonStyle(PlainButtonStyle())
                                   }


                        Text("Confirm Password")
                            .font(.headline)
                            .opacity(1)
                        ZStack(alignment: .trailing) {
                                       if isConfirmPasswordVisible {
                                           TextField("Confirm Password", text: $confirmPassword)
                                               .padding()
                                               .background(Color.gray.opacity(0.2))
                                               .cornerRadius(10)
                                               .padding(.horizontal, 20)
                                               .textContentType(.password)
                                               .opacity(1)
                                       } else {
                                           SecureField("Confirm Password", text: $confirmPassword)
                                               .padding()
                                               .background(Color.gray.opacity(0.2))
                                               .cornerRadius(10)
                                               .padding(.horizontal, 20)
                                               .textContentType(.password)
                                               .opacity(1)
                                       }

                                       Button(action: {
                                           isConfirmPasswordVisible.toggle()
                                       }) {
                                           Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                               .foregroundColor(.gray)
                                               .padding(.trailing, 25)
                                       }
                                       .buttonStyle(PlainButtonStyle())
                                   }

                        HStack {
                            Spacer()
                            Button(action: {
                                // Present the role selection sheet
                                isRoleSelectionPresented = true
                            }) {
                                Text("Choose Role")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .frame(width: 140, height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                                    .scaleEffect(showError ? 0.8 : 1.0)
                                    .animation(.spring())
                            }
                            Spacer()
                        }
                        
                    } else {
                        Text("Phone Number")
                            .font(.headline)
                            .opacity(1)

                        TextField("Phone Number", text: $phoneNumber)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .keyboardType(.phonePad)
                            .opacity(1)

                        Text("Name")
                            .font(.headline)
                            .opacity(1)

                        TextField("Name", text: $Name)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .opacity(1)
                        Text("First Name")
                            .font(.headline)
                            .opacity(1)

                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .opacity(1)

                        Text("Age")
                            .font(.headline)
                            .opacity(1)

                        TextField("Age", text: $age)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .keyboardType(.numberPad)
                            .opacity(1)

                        Spacer()
                    }
                }
                .padding(.bottom, 20)
               
                             .sheet(isPresented: $isRoleSelectionPresented) {
                                 RoleSelectionView(selectedRole: $selectedRole,isRoleSelectionPresented: $isRoleSelectionPresented)
                             }
                             
                Button(action: {
                    if isEmailPasswordValidated {
                        
                        signUp()
                    } else {
                        validateEmailPassword()
                    }
                }) {
                    Text(isEmailPasswordValidated ? "Sign Up" : "Next")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .scaleEffect(showError ? 0.8 : 1.0)
                        .animation(.spring())
                }
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
             

                               Spacer()
                           }
            .padding(20)
            .background(Color.gray.opacity(0.1))
            .edgesIgnoringSafeArea(.all)
        }
    }
    

    func validateEmailPassword() {
        guard selectedRole != nil else {
                errorMessage = "Please choose a role."
                showError = true
                return
            }
        if email.isEmpty || $password.wrappedValue.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all required fields."
            showError = true
            return
        }

        if $password.wrappedValue != confirmPassword {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }

        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            showError = true
            return
        }

        if $password.wrappedValue.count < 6 || !$password.wrappedValue.containsNumber() || !$password.wrappedValue.containsUppercase() {
            errorMessage = "Password must be at least 6 characters long, contain 1 number, and 1 uppercase letter."
            showError = true
            return
        }

       

        withAnimation {
            isEmailPasswordValidated = true
        }
    }
    func signUp() {
        let url = URL(string: "http://localhost:9090/user/signup")! // Replace with your actual server URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "Phone_number": phoneNumber,
            "role": selectedRole!, // Set the role to a default value or adjust as needed
            "name": Name,
            "first_name": firstName,
            "age": Int(age) ?? 0 // Convert age to an integer; provide a default value if conversion fails
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { // Wrap UI-related code in the main thread
                if let error = error {
                    print("Error: \(error)")
                    // Handle the error, show an alert, etc.
                    return
                }

                if let data = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                        // Check if the signup was successful
                        if let success = responseJSON?["success"] as? Bool, success {
                            // Signup successful, show an alert
                            showSuccessAlert = true
                        } else {
                            // Handle other cases, e.g., display an error alert
                            errorMessage = "Sign up failed. Please try again."
                            showError = true
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        errorMessage = "Sign up failed. Please try again."
                        showError = true
                    }
                }
            }
        }.resume()
    }
    }


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
SignUpView()
    }
}
extension String {
    func containsNumber() -> Bool {
        let numberRange = self.rangeOfCharacter(from: .decimalDigits)
        return numberRange != nil
    }
    
    func containsUppercase() -> Bool {
        let uppercaseRange = self.rangeOfCharacter(from: .uppercaseLetters)
        return uppercaseRange != nil
    }
}
