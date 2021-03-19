//
//  TagScan+CoreDataProperties.swift
//  EventPicker
//
//  Created by Benedict Pupp on 3/19/21.
//
//

import Foundation
import CoreData


extension TagScan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagScan> {
        return NSFetchRequest<TagScan>(entityName: "TagScan")
    }

    @NSManaged public var eid: String?
    @NSManaged public var id: UUID?
    @NSManaged public var scanDate: Date?
    @NSManaged public var tagEvent: NSSet?

}

extension TagScan : Identifiable {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
}

// MARK: Generated accessors for tagEvent
extension TagScan {

    @objc(addTagEventObject:)
    @NSManaged public func addToTagEvent(_ value: TagEvent)

    @objc(removeTagEventObject:)
    @NSManaged public func removeFromTagEvent(_ value: TagEvent)

    @objc(addTagEvent:)
    @NSManaged public func addToTagEvent(_ values: NSSet)

    @objc(removeTagEvent:)
    @NSManaged public func removeFromTagEvent(_ values: NSSet)

}
