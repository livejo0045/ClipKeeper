//
//  ClipKeeperApp.swift
//  ClipKeeper
//
//  Created by Jonas Reveley on 07/03/2026.
//

import SwiftUI
import CoreData

@main
struct ClipKeeperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
