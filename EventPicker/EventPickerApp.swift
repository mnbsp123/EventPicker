//
//  EventPickerApp.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//

import SwiftUI

@main
struct EventPickerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
