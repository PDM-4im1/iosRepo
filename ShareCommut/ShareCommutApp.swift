//
//  ShareCommutApp.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 27/11/2023.
//

import SwiftUI


@main
struct ShareCommutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           EmergencyRideView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
