//
//  menuplannerApp.swift
//  menuplanner
//
//  Created by Julen Miner on 1/9/21.
//

import SwiftUI

@main
struct menuplannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
