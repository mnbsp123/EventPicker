//
//  Persistence.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for current in 0..<10 {
            let newItem = TagScan(context: viewContext)
            newItem.eid = "98765432109876" + String(current)
            newItem.scanDate = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    public var context: NSManagedObjectContext {  // (1)
        get {
            return self.container.viewContext
        }
    }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EventPicker")
        
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("EventPicker.sqlite")

        assert(FileManager.default.fileExists(atPath: url.path))
        
        try! container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: "sqlite", options: nil)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    
    func save(){
        let viewContext = container.viewContext
        if viewContext.hasChanges{
            do{
                try viewContext.save()
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
