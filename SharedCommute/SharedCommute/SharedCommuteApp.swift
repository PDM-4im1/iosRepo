//
//  SharedCommuteApp.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 27/11/2023.
//
import SwiftUI

@main
struct SharedCommuteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            EmergencyRideView()

            //ClientMappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))
            // MappingView(internalsource: .constant(""), internaldestination: .constant(""), selectedHoursMapping: .constant(0), selectedMinutesMapping: .constant(0), initialidcovoiturage: .constant(""))              // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
