//
//  OtpValidation.swift
//  login
//
//  Created by Mac Mini on 30/11/2023.
//

import SwiftUI


@available(iOS 15.0, *)
struct OtpValidation: View {
    @State private var otp: [String] = ["", "", "", ""]
    var body: some View {
        ZStack {
          Color("BgColor").edgesIgnoringSafeArea(.all)

          VStack {
            Text("Enter OTP")
              .font(.system(size: 30, weight: .bold))
              .padding()

              HStack(spacing: 20) {
                  ForEach(0..<4) { index in
                      TextField("", text: $otp[index])
                          .frame(width: 50, height: 50)
                          .keyboardType(.numberPad)
                          .multilineTextAlignment(.center)
                          .textContentType(.oneTimeCode)
                          .cornerRadius(10)
                          .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color.black, lineWidth: 1)
                          )
                          .onChange(of: otp[index]) { newText in
                              // Update the otp property
                              if newText.count == 1 {
                                  otp[index] = newText
                              } else {
                                  otp[index] = ""
                              }
                          }
                  }
              }
              .padding(.top, 20)
              .padding(.horizontal, 20)
              .offset(y: -0)
              
              Text("Didn't recieve the reset code ?")
                  .foregroundColor(Color.black.opacity(0.4))
                  .padding(.top,10)


              NavigationLink(
                destination: ResetPass() ,label: {
                    PrimaryButton(title: "Submit")
                    // Handle OTP validation logic here
                    // If OTP is valid, navigate to the desired screen
                        .padding()
                    })

            Spacer()
          }
          .padding()
        }
      }
}

@available(iOS 15.0, *)
struct OtpValidation_Previews: PreviewProvider {
    static var previews: some View {
        OtpValidation()
    }
}
