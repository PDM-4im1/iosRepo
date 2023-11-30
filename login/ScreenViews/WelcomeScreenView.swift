import SwiftUI

@available(iOS 15.0, *)
struct WelcomeScreenView: View {
    
    var body: some View {
        NavigationView {
           
            ZStack {
                
                Image("cars")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .opacity(0.25)
                VStack {
                    HStack{
                        // Replace the image with a large "Sign In" text
                        Text("Sign")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))
                        Text("In")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(Color(.black))
                            .padding(.horizontal,5)
                            .padding(.vertical,90)
                            }
                    
                            
                                
                                
                        

                    PrimaryButton(title: "Get Started")
                        .padding(.top,90)


                    NavigationLink(
                        destination: SignInScreenView(signInViewModel: SignInViewModel()).navigationBarHidden(true),
                        
                        label: {
                            Text("Sign In")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("PrimaryColor"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding(.vertical)
                        })
                        .navigationBarHidden(true)
                    
                    HStack {
                        Text("New around here? ")
                        NavigationLink(
                            destination: SignupScreen(signUpViewModel: SignUpViewModel()).navigationBarHidden(true),
                            label: {
                                Text("Sign up")
                                    .foregroundColor(Color("PrimaryColor"))
                            })
                    }
                }
                .padding(.bottom,70)
                .padding(.horizontal,20)
            }
        }
    }
}

@available(iOS 15.0, *)
struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
