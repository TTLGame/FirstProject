//
//  Pages+CoreDataProperties.swift
//  Project
//
//  Created by geotech on 29/06/2021.
//
//

import Foundation
import CoreData


extension Pages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pages> {
        return NSFetchRequest<Pages>(entityName: "Pages")
    }

    @NSManaged public var page: Int16
    @NSManaged public var perPage: Int16
    @NSManaged public var supText: String?
    @NSManaged public var supUrl: String?
    @NSManaged public var total: Int16
    @NSManaged public var totalPages: Int16
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Pages {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Person)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Person)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}

extension Pages : Identifiable {

}
