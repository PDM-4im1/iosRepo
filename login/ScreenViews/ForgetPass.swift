import SwiftUI


@available(iOS 15.0, *)
struct ForgetPass: View {
    @State private var email: String = ""
    @State private var isValidEmail: Bool = false
    @State private var showErrorMessage: Bool = false
    @State private var shouldNavigateToOtp: Bool = false

    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)

            VStack {
                Text("Reset Password")
                    .font(.system(size: 30, weight: .bold))
                    .padding()

                TextField("Email address", text: $email)
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.vertical)
                    .onChange(of: email) { _ in
                        // Update email validity and error message visibility
                        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                        isValidEmail = predicate.evaluate(with: email)

                        if isValidEmail {
                            showErrorMessage = false
                        } else {
                            showErrorMessage = true
                        }
                    }

                // Display error message conditionally
                if showErrorMessage {
                    Text("Email is not valid")
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(
                    destination: OtpValidation(),
                    isActive: $shouldNavigateToOtp
                ) {
                    EmptyView()
                }

                Button(action: {
                    // Handle button press
                    if isValidEmail {
                        // Set shouldNavigateToOtp to true to trigger navigation
                        shouldNavigateToOtp = true
                    } else {
                        // Display error message
                        print("Email is invalid. Please enter a valid email address.")
                    }
                }) {
                    PrimaryButton(title: "Send Reset Link")
                        .padding()
                }

                Spacer()
            }
        }
    }
}


@available(iOS 15.0, *)
struct ForgetPass_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPass()
    }
}
