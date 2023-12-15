//
//  ShareCommuteApp.swift
//  ShareCommute
//
//  Created by Rihem Drissi on 14/12/2023.
//

import SwiftUI

@main
struct ShareCommuteApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            // EmergencyRideView()
            NotificationView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
