//
//  CovoiturageView.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI

struct CovoiturageView: View {
    let drivers = [
        Driver(name: "Driver 1",phone: "22 555 888", car: "cito"),
            Driver(name: "Driver 2",phone: "25 896 314",car: "bmw"),
            Driver(name: "Driver 3",phone: "26 302 001",car: "kadon")
        ]
    var body: some View {
        List(drivers) { driver in
            EmgDriverCell(driver: driver)
        }
            .listStyle(PlainListStyle())
            .padding(.bottom, 8).padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.green, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
       
    }
}


struct CovoiturageView_Previews: PreviewProvider {
    static var previews: some View {
        CovoiturageView()
    }
}
