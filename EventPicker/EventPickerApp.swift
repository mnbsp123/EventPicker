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

    
    @StateObject private var event = EventViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(event)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
