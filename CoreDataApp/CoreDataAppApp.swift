//
//  CoreDataAppApp.swift
//  CoreDataApp
//
//  Created by Hopp, Dan on 11/13/23.
//

import SwiftUI

@main
struct CoreDataAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
