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
MappingView()                // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
