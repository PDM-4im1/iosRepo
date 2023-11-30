//
//  ContentView.swift
//  login



import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
   
    var body: some View {
        WelcomeScreenView()
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PrimaryButton: View {
    var title: String
    var action: (() -> Void)? = nil // Allow a default action or custom action

    var body: some View {
        Button(action: action ?? {}) { // Use the default action if no custom action is provided
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("PrimaryColor"))
                .cornerRadius(50)
        }
    }
}








