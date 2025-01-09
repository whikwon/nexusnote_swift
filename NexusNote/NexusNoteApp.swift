//
//  NexusNoteApp.swift
//  NexusNote
//
//  Created by Whi Kwon on 1/9/25.
//

import SwiftUI

@main
struct NexusNoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
