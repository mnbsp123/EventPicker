//
//  ContentView.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var event:EventViewModel
    
    
    @State private var editMode = EditMode.inactive
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TagScan.eid, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TagScan>

    var body: some View {
        
        
        List {
            ForEach(items) { oneTage in
                NavigationLink(destination:
                                NavigationLazyView(EventView(singleTagScan: oneTage, tagScans: items, editMode: editMode
                                                             //, selectKeeper: selectKeeper
                                ))
                                .environmentObject(event)) {
                    TagScanRowView(tagScan: oneTage, showDetails: false)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif

            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
        .onAppear()
        {
            let dataSeed = DataSeed(context: self.viewContext)
            dataSeed.seed()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = TagScan(context: viewContext)
            newItem.scanDate = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
