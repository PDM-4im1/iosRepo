//
//  SharedCommuteApp.swift
//  SharedCommute
//
//  Created by Nasri Mootez on 27/11/2023.
//
import SwiftUI

@main
struct SharedCommuteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CovoiturageTableView()
        
          //      .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
