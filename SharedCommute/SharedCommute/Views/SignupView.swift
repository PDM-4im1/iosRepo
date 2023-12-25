import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phoneNumber = ""
    @State private var fullName = ""
    @State private var age = ""

    @State private var isEmailPasswordValidated = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack {
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
                                  .padding()
                          }
                          .transition(.move(edge: .top))
                          .padding(.top, 20)
                          Spacer()
                      }
                  }
                Spacer()

                Image("logo")
                    .resizable()
                    .frame(width: 230, height: 260)

                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

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

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .textContentType(.password)
                            .opacity(1)

                        Text("Confirm Password")
                            .font(.headline)
                            .opacity(1)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .textContentType(.password)
                            .opacity(1)

                        Spacer()
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

                        Text("Full Name")
                            .font(.headline)
                            .opacity(1)

                        TextField("Full Name", text: $fullName)
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

                Button(action: {
                    if isEmailPasswordValidated {
                        //signUp()
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
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all required fields."
            showError = true
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }

        // Perform other validations for email and password,
        // such as checking email format or password strength

        withAnimation {
            isEmailPasswordValidated = true
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
SignUpView()
    }
}
