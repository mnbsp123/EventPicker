//
//  TagEvent+CoreDataProperties.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//
//

import Foundation
import CoreData


extension TagEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEvent> {
        return NSFetchRequest<TagEvent>(entityName: "TagEvent")
    }

    @NSManaged public var actionId: Int64
    @NSManaged public var eid: String?
    @NSManaged public var eventDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var productId: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var typeId: Int64
    @NSManaged public var eventAction: EventAction?
    @NSManaged public var eventProduct: EventProduct?
    @NSManaged public var eventType: EventType?
    @NSManaged public var tagScan: TagScan?

}

extension TagEvent : Identifiable {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}
