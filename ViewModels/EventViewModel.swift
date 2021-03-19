//
//  EventTypeViewModel.swift
//  BeefPassport
//
//  Created by Benedict Pupp on 1/11/21.
//

import SwiftUI
import Combine
import CoreData



class EventViewModel: ObservableObject {
    
    private var container = PersistenceController.shared.container
    private var subscriptions = Set<AnyCancellable>()
  
    
    @Published var pickerTypes = Array(arrayLiteral: String("Select Your Event"))
    @Published var pickerActions = Array(arrayLiteral: String("Select Your Event Action"))
    var pickerProducts: [String] {
        get {
            print("EventViewModel.pickerProducts.get: eventProducts.count: \(eventProducts.count), selectedEventAction: \(selectedEventAction), pickerActions[selectedEventAction]: \(pickerActions[selectedEventAction])")
            return ["Select Your Product"] +
                eventProducts.filter { $0.actionName == pickerActions[selectedEventAction] }
                .map { (product) in (product.productName ?? "Unknown")}
        }
        set { _ = newValue }
    }
    
    @Published var selectedEventType = 0
    {
        didSet {
            print("EventViewModel.selectedEventType changed to \(selectedEventType).")
            if (selectedEventType != 1){
                selectedEventAction = 0
            }
        }
    }
    
    //https://stackoverflow.com/questions/60082411/swiftui-hierarchical-picker-with-dynamic-data-crashes?noredirect=1&lq=1
    @Published var selectedEventAction = 0
    {
        didSet {
            print("EventViewModel.selectedEventAction changed to \(selectedEventAction).")
            //if (selectedEventAction == 0){
                selectedEventProduct = 0
            //}
        }
    }
    
    @Published var id: UUID = UUID()
    @Published var selectedEventProduct = 0
//    {
//        willSet {
//            //print("Product will change: \(selectedEventProduct)")
//        }
//        didSet {
//            print("EventViewModel.selectedEventProduct changed to \(selectedEventProduct).")
//            //print("Product did  change: \(selectedEventProduct)")
//        }
//    }
        
    @Published var eventTypes: [EventType] = []
    @Published var eventActions: [EventAction] = []
    @Published var eventProducts: [EventProduct] = []
    
    @Published var mostRecentTagScanEid: String?
    @Published var tagScans = [TagScan]()
    @Published var tagEvents = [TagEvent]()
    @Published var maxScanDate: Date = .distantPast
    
    
    init(){
        print("Starting EventViewModel init...")
        _ = fetchEvents()
        mostRecentTagScanEid = nil
    }

    func fetchEvents() -> Bool {
        print("Starting EventViewModel fetchEvents")
        
        if fetchEventTypes() == false{
            return false
        }
        if fetchEventActions() == false{
            return false
        }
        if fetchEventProducts() == false{
            return false
        }
        if fetchTagScans() == false{
            return false
        }
        if fetchTagEvents() == false{
            return false
        }
 
        return true
    }
    
    func fetchEventTypes() -> Bool {
       
        eventTypes = []
        pickerTypes = Array(arrayLiteral: String("Select Your Event"))

        EventPicker.PersistenceController.shared.context.perform {
            let request1: NSFetchRequest<EventType> = EventType.fetchRequest()
            if let items = try? EventPicker.PersistenceController.shared.context.fetch(request1) {
                for item in items.sorted(by: { (itemA, itemB) -> Bool in
                    itemA.typeId < itemB.typeId
                }) {
                    if item.typeName ?? "" != ""
                    {
                        self.eventTypes.append(item)
                        
                        // exclude fabbed-up 'Tag Replacement' event; this one only exists locally
                        if item.sort < 100{
                            self.pickerTypes.append(item.typeName ?? "Select")
                        }
                    }
                }
                //self.eventTypes = types
            }
            
        }
        return true
    }
        
    func fetchEventActions() -> Bool {
            
        var results = true
        eventActions = []
        pickerActions = Array(arrayLiteral: String("Select Your Event Action"))

        EventPicker.PersistenceController.shared.context.perform {
            let request2: NSFetchRequest<EventAction> = EventAction.fetchRequest()
            if let items = try? EventPicker.PersistenceController.shared.context.fetch(request2) {
                for item in items.sorted(by: { (itemA, itemB) -> Bool in
                    itemA.actionId < itemB.actionId
                })  {
                    if item.actionName == nil{
                        results = false
                    }
                    self.eventActions.append(item)
                    self.pickerActions.append(item.actionName ?? "Select")
                }
//                self.eventActions = actions
            }
            
        }
        return results
    }
            
    func fetchEventProducts() -> Bool {
        
        var results = true
            
        eventProducts = []
        
        EventPicker.PersistenceController.shared.context.perform {
            let request3: NSFetchRequest<EventProduct> = EventProduct.fetchRequest()
            if let items = try? EventPicker.PersistenceController.shared.context.fetch(request3) {
                for item in items.sorted(by: { (itemA, itemB) -> Bool in
                    itemA.productName ?? "" < itemB.productName ?? ""
                })  {
                    if item.productName == nil{
                        results = false
                    }
                    self.eventProducts.append(item)
                    //self.pickerProducts.append(item.productName ?? "Select")
                }
                //self.eventProducts = products
            }
            
        }
        return results
    }
    
            
    func fetchTagScans() -> Bool {
        
        var scans: [TagScan] = []
            
        EventPicker.PersistenceController.shared.context.perform {
            let request4: NSFetchRequest<TagScan> = TagScan.fetchRequest()
            if let items = try? EventPicker.PersistenceController.shared.context.fetch(request4) {
                for item in items {
                    scans.append(item)
                    if self.maxScanDate < item.scanDate ?? self.maxScanDate
                    {
                        self.maxScanDate = item.scanDate ?? self.maxScanDate
                    }
                }
                self.tagScans = scans
            }
            
        }
        return true
    }
            
    
    
            
    func fetchTagEvents() -> Bool {
        
        var events: [TagEvent] = []
            PersistenceController.shared.context.perform {
            let request5: NSFetchRequest<TagEvent> = TagEvent.fetchRequest()
            if let items = try? PersistenceController.shared.context.fetch(request5) {
                for item in items.sorted(by: { (itemA, itemB) -> Bool in
                    itemA.eid ?? "" < itemB.eid ?? ""
                })  {
                    events.append(item)
                }
                
                self.tagEvents = events
            }
        }
        
        return true
    }
    
    
    public func updateEvent(tagEvent: TagEvent, notes: String) -> Bool{
        let selectedPickerTypeName = pickerTypes[selectedEventType]
        let selectedType = eventTypes.first( where: { $0.typeName == selectedPickerTypeName } )
        
        let selectedPickerActionName = pickerActions[(selectedEventType == 1 ? selectedEventAction : 0)]
        let selectedAction = eventActions.first( where: { $0.actionName == selectedPickerActionName } )
        
        let selectedPickerProductName = selectedEventType != 1 || selectedEventAction == 0 ? "" : pickerProducts[selectedEventProduct]
        let selectedProduct = selectedPickerProductName == "" ? nil : eventProducts.first( where: { $0.productName == selectedPickerProductName } )
        
        
        
        
        tagEvent.typeId = selectedType?.typeId ?? 0
        tagEvent.eventType = selectedType
        tagEvent.actionId = selectedAction?.actionId ?? 0
        tagEvent.eventAction = selectedAction
        tagEvent.productId = selectedProduct?.productId ?? 0
        tagEvent.eventProduct = selectedProduct
        tagEvent.notes = notes
        tagEvent.eventDate = Date()
        
        do{
            PersistenceController.shared.context.automaticallyMergesChangesFromParent = true
            try PersistenceController.shared.context.save()
        } catch {
            print(error.localizedDescription)
            return false
        }
                
        return true
    }
    
    
    public func deleteEvent(tagEvent: TagEvent) -> Bool{

        do{
            PersistenceController.shared.context.automaticallyMergesChangesFromParent = true
            //try
                PersistenceController.shared.context.delete(tagEvent)
            try
                PersistenceController.shared.context.save()
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        selectedEventType = 0
        selectedEventAction = 0
        selectedEventProduct = 0
        return true
    }
    
    public func addEvent(tagScan: TagScan, notes: String) -> Bool {
        
        let selectedPickerTypeName = pickerTypes[selectedEventType]
        var selectedType = eventTypes.first( where: { $0.typeName == selectedPickerTypeName } )
        
        // reload and retry one time.
        if selectedType == nil{
            _ = fetchEvents()
            selectedType = eventTypes.first( where: { $0.typeName == selectedPickerTypeName } )
        }
        
        guard selectedType != nil else { return false }
        
        
        let selectedPickerActionName = pickerActions[(selectedEventType == 1 ? selectedEventAction : 0)]
        let selectedAction = eventActions.first( where: { $0.actionName == selectedPickerActionName } )
        
        let selectedPickerProductName = selectedEventType != 1 || selectedEventAction == 0 ? "" : pickerProducts[selectedEventProduct]
        let selectedProduct = selectedPickerProductName == "" ? nil : eventProducts.first( where: { $0.productName == selectedPickerProductName } )
        
        
        let newTagEvent = TagEvent(context: PersistenceController.shared.context)
        
        newTagEvent.tagScan = tagScan
        newTagEvent.eid = tagScan.eid
        
        newTagEvent.typeId = selectedType?.typeId ?? 0
        newTagEvent.eventType = selectedType
        newTagEvent.actionId = selectedAction?.actionId ?? 0
        newTagEvent.eventAction = selectedAction
        newTagEvent.productId = selectedProduct?.productId ?? 0
        newTagEvent.eventProduct = selectedProduct
        newTagEvent.notes = notes
        newTagEvent.eventDate = Date()
        
        
        do{
            PersistenceController.shared.context.automaticallyMergesChangesFromParent = true
            try PersistenceController.shared.context.save()
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
//    func saveScannedData(nextPage: ScanPageNext, replacementTagScanEid: String?, replacementTagScanDate: Date?, currentScannedEid: String?, previousReplacementEid: String?) -> (tagScan: TagScan?, errorMessage: String?) {
//        
//        guard currentScannedEid != "" else { return (nil, "No tag currently scanned") }
//        
//        // if we came from the Event Edit page, this is a replacement scan
//        if nextPage == ScanPageNext.pageEventEditView{
//            
//            
//            print("EventViewModle.saveScannedData(): self._replacementTagScanDate: \(String(describing: replacementTagScanDate))")
//            
//                
//            if replacementTagScanEid == currentScannedEid {
//                return (nil, "Scanned Tag cannot replace itself.")
//            }
//            
//            let filteredTagScans = tagScans.filter { $0.eid == replacementTagScanEid }
//                //&& $0.scanDate! >= replacementTagScanDate!.addingTimeInterval(-10) && $0.scanDate! <= replacementTagScanDate!.addingTimeInterval(+10) }
//            //    && $0.scanDate == replacementTagScanDate
//            
//            if filteredTagScans.count != 1 {
//                return (nil, "Tag \(replacementTagScanEid ?? "?") not found for replacement.")
//            }
//            let selectedType = eventTypes.first( where: { $0.typeName == "Tag Replacement" } )
//            
//            // Can't stack replacements; so look for one and update it.
//            var newTagEvent = tagEvents.first( where: { $0.eid == replacementTagScanEid && $0.typeId == selectedType?.typeId })
//                
//            var notFound = false
//            if (newTagEvent == nil){
//                // else create a new replacement.
//                newTagEvent = TagEvent(context: PersistenceController.shared.container.viewContext)
//                notFound = true
//            }
//            
//            newTagEvent!.tagScan = filteredTagScans.sorted(by: { (itemA, itemB) -> Bool in
//                itemA.scanDate ?? Date.distantPast < itemB.scanDate ?? Date.distantPast
//            }).first
//            newTagEvent!.eid = replacementTagScanEid
//            
//            newTagEvent!.typeId = selectedType?.typeId ?? 0
//            newTagEvent!.eventType = selectedType
//            newTagEvent!.actionId = 0
//            newTagEvent!.eventAction = nil
//            newTagEvent!.productId = 0
//            newTagEvent!.eventProduct = nil
//            newTagEvent!.notes = currentScannedEid
//            newTagEvent!.eventDate = Date()
//            
//            
//            do{
//                try PersistenceController.shared.container.viewContext.save()
//                
//                if notFound{
//                    tagEvents.append(newTagEvent!)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//            
//            return (nil, nil)
//        }
//        else {
//            if nextPage == ScanPageNext.pageTagReplacement {
//                
//                if replacementTagScanEid == currentScannedEid {
//                    return (nil, "Scanned Tag cannot replace itself.")
//                }
//                let selectedType = eventTypes.first( where: { $0.typeName == "Tag Replacement" } )
//                
//                let filteredTagEvents = tagEvents.filter { $0.eid == replacementTagScanEid  && $0.typeId == selectedType?.typeId ?? 0 && $0.notes == previousReplacementEid }
//                
//                let tagEvent = filteredTagEvents.first
//                
//                guard tagEvent != nil else { return (nil, "Replacement Tag Event not found.") }
//                
//                tagEvent!.notes = currentScannedEid
//                
//                do{
//                    try PersistenceController.shared.container.viewContext.save()
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                return (nil, nil)
//            }
//            else {
//                
//                let filteredTagScans = tagScans.filter { $0.eid == currentScannedEid }
//                
//                guard filteredTagScans.count == 0 else { return (nil, "Scanned EID is already active.") }
//                
//                let newTagScan = TagScan(context: PersistenceController.shared.container.viewContext)
//                newTagScan.eid = currentScannedEid!
//                newTagScan.scanDate = Date()
//                
//                do{
//                    try PersistenceController.shared.container.viewContext.save()
//                    
//                    tagScans.append(newTagScan)
//                } catch {
//                    print(error.localizedDescription)
//                }
//                
//                return (newTagScan, nil)
//            }
//        }
//    }
}
