//
//  DataSeed.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//

import Foundation
import CoreData

public class DataSeed {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    public func seed(){
        
        seedEventTypes()
        seedEventActions()
        seedEventProducts()
        
        seedTagScans()
        seedTagEvents()
    }
    
    private func seedEventTypes(){
        
        let types = [
            (typeId: 1, typeName: "Processing"),
            (typeId: 2, typeName: "Move In"),
            (typeId: 3, typeName: "Move Out"),
            (typeId: 4, typeName: "Death"),
        ]
        
        for eventType in types {
            let newEventType = NSEntityDescription.insertNewObject(forEntityName: "EventType", into: context) as! EventType
            
            newEventType.typeId = Int64(eventType.typeId)
            newEventType.typeName = eventType.typeName
        }
        
        do {
            try context.save()
        }
        catch _ {
        }
    }
    
    private func seedEventActions(){
        
        let actions = [
            (actionId: 1, actionName: "Feed"),
            (actionId: 2, actionName: "Growth"),
            (actionId: 3, actionName: "Vitamin"),
            (actionId: 4, actionName: "Supplement"),
            (actionId: 5, actionName: "Pharm")
        ]
        
        for eventAction in actions {
            let newEventAction = NSEntityDescription.insertNewObject(forEntityName: "EventAction", into: context) as! EventAction
            
            newEventAction.actionId = Int64(eventAction.actionId)
            newEventAction.actionName = eventAction.actionName
        }
        
        do {
            try context.save()
        }
        catch _ {
        }
    }
    
    private func seedEventProducts(){
        
        let products = [
            (actionId: 1, actionName: "Feed",       productId: 1, productName: "Feed 1"),
            (actionId: 1, actionName: "Feed",       productId: 2, productName: "Feed 2"),
            (actionId: 1, actionName: "Feed",       productId: 3, productName: "Feed 3"),
            (actionId: 2, actionName: "Growth",     productId: 4, productName: "Growth 4"),
            (actionId: 2, actionName: "Growth",     productId: 5, productName: "Growth 5"),
            (actionId: 3, actionName: "Vitamin",    productId: 6, productName: "Vitamin 6"),
            (actionId: 3, actionName: "Vitamin",    productId: 7, productName: "Vitamin 7"),
            (actionId: 3, actionName: "Vitamin",    productId: 8, productName: "Vitamin 8"),
            (actionId: 4, actionName: "Supplement", productId: 9, productName: "Supplement 9"),
            (actionId: 5, actionName: "Pharm",      productId: 10, productName: "Pharm 10"),
            (actionId: 5, actionName: "Pharm",      productId: 11, productName: "Pharm 11"),
            (actionId: 5, actionName: "Pharm",      productId: 12, productName: "Pharm 12"),
            (actionId: 5, actionName: "Pharm",      productId: 13, productName: "Pharm 13")
        ]
        
        for eventProduct in products {
            let newEventProduct = NSEntityDescription.insertNewObject(forEntityName: "EventProduct", into: context) as! EventProduct
            
            newEventProduct.actionId = Int64(eventProduct.actionId)
            newEventProduct.actionName = eventProduct.actionName
            newEventProduct.productId = Int64(eventProduct.productId)
            newEventProduct.productName = eventProduct.productName
        }
        
        do {
            try context.save()
        }
        catch _ {
        }
    }
    
    private func seedTagScans(){
        let scans = [
            
            (id: UUID(), eid: "9876543210987651"),
            (id: UUID(), eid: "9876543210987652"),
            (id: UUID(), eid: "9876543210987653"),
            (id: UUID(), eid: "9876543210987654"),
            (id: UUID(), eid: "9876543210987655"),
        ]
        
        
        
        for scan in scans {
            let tagScan = NSEntityDescription.insertNewObject(forEntityName: "TagScan", into: context) as! TagScan
            
            tagScan.id = scan.id
            tagScan.eid = scan.eid
        }
        
        do {
            try context.save()
        }
        catch _ {
        }
    }
    
    private func seedTagEvents(){
        
        let eventTypeFetchRequest = NSFetchRequest<EventType>(entityName: "EventType")
        let allEventTypes = try! context.fetch(eventTypeFetchRequest)
        
        let processing = allEventTypes.filter({(c: EventType) -> Bool in
            return c.typeName == "Processing"
        }).first
        
        let moveIn = allEventTypes.filter({(c: EventType) -> Bool in
            return c.typeName == "Move In"
        }).first
        
        let moveOut = allEventTypes.filter({(c: EventType) -> Bool in
            return c.typeName == "Move Out"
        }).first
        
        let death = allEventTypes.filter({(c: EventType) -> Bool in
            return c.typeName == "Death"
        }).first
        
        let tagReplacement = allEventTypes.filter({(c: EventType) -> Bool in
            return c.typeName == "Tag Replacement"
        }).first
        
        
        
        
        let eventActionFetchRequest = NSFetchRequest<EventAction>(entityName: "EventAction")
        let allEventActions = try! context.fetch(eventActionFetchRequest)
        
        let feed = allEventActions.filter({(c: EventAction) -> Bool in
            return c.actionName == "Feed"
        }).first
        
        let growth = allEventActions.filter({(c: EventAction) -> Bool in
            return c.actionName == "Growth"
        }).first
        
        let vitamin = allEventActions.filter({(c: EventAction) -> Bool in
            return c.actionName == "Vitamin"
        }).first
        
        let supplement = allEventActions.filter({(c: EventAction) -> Bool in
            return c.actionName == "Supplement"
        }).first
        
        let pharm = allEventActions.filter({(c: EventAction) -> Bool in
            return c.actionName == "Pharm"
        }).first

        
        let eventProductFetchRequest = NSFetchRequest<EventProduct>(entityName: "EventProduct")
        let allEventProducts = try! context.fetch(eventProductFetchRequest)

        let feed1 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Feed 1"
        }).first

        let feed2 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Feed 2"
        }).first
        
        let growth5 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Growth 5"
        }).first

        let vitamin7 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Vitamin 7"
        }).first

        let supplement9 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Supplement 9"
        }).first

        let pharm10 = allEventProducts.filter({(c: EventProduct) -> Bool in
            return c.productName == "Pharm 10"
        }).first
        
        let tagScanFetchRequest = NSFetchRequest<TagScan>(entityName: "TagScan")
        let allTagScans = try! context.fetch(tagScanFetchRequest)

        let eid1 = allTagScans.filter({(c: TagScan) -> Bool in
            return c.eid == "9876543210987651"
        }).first

        let eid2 = allTagScans.filter({(c: TagScan) -> Bool in
            return c.eid == "9876543210987652"
        }).first

        let eid3 = allTagScans.filter({(c: TagScan) -> Bool in
            return c.eid == "9876543210987653"
        }).first

        
        
        
        
        
            let events = [
                
                (id: UUID(), eid: eid1?.eid, eventDate: Date(), typeId: processing?.typeId, actionId: feed?.actionId, productId: feed1?.productId, notes: "processing feed feed1", timestamp: Date()),
                (id: UUID(), eid: eid1?.eid, eventDate: Date(), typeId: processing?.typeId, actionId: feed?.actionId, productId: feed2?.productId, notes: "processing feed feed2", timestamp: Date()),
                (id: UUID(), eid: eid2?.eid, eventDate: Date(), typeId: processing?.typeId, actionId: growth?.actionId, productId: growth5?.productId, notes: "processing growth growth5", timestamp: Date()),
                (id: UUID(), eid: eid1?.eid, eventDate: Date(), typeId: moveIn?.typeId, actionId: nil, productId: nil, notes: "movein", timestamp: Date()),
                (id: UUID(), eid: eid2?.eid, eventDate: Date(), typeId: death?.typeId, actionId: nil, productId: nil, notes: "death", timestamp: Date()),
                (id: UUID(), eid: eid3?.eid, eventDate: Date(), typeId: tagReplacement?.typeId, actionId: nil, productId: nil, notes: "tagReplacement", timestamp: Date()),
            ]
            
            
            
            for event in events {
                let tagEvent = NSEntityDescription.insertNewObject(forEntityName: "TagEvent", into: context) as! TagEvent
                
                tagEvent.id = event.id
                tagEvent.eid = event.eid
                tagEvent.eventDate = event.eventDate
                tagEvent.typeId = event.typeId ?? 0
                tagEvent.actionId = event.actionId ?? 0
                tagEvent.productId = event.productId ?? 0
                tagEvent.notes = event.notes
                tagEvent.timestamp = event.timestamp
            }
            
            do {
                try context.save()
            }
            catch _ {
            }
        
        
        
    }
}
