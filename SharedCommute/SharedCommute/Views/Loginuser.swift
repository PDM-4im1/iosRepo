import SwiftUI
struct LoginView: View {
@State private var email = ""
@State private var password = ""
@State private var showForgotPassword = false // New state variable

var body: some View {
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
            // Perform login action
        }) {
            Text("Login")
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(25)
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

            Button(action: {
                // Navigate to sign-up screen
            }) {
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
}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
