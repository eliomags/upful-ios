//
//  SavedScreener+CoreDataProperties.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedScreener {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<SavedScreener> {
        return NSFetchRequest<SavedScreener>(entityName: "SavedScreener")
    }

    @NSManaged public var screenDescription: String?
    @NSManaged public var title: String
    @NSManaged public var imageUrlString: String?
    @NSManaged public var savedScreenerParameter: NSSet

}

// MARK: Generated accessors for savedScreenerParameter
extension SavedScreener {

    @objc(addSavedScreenerParameterObject:)
    @NSManaged public func addToSavedScreenerParameter(_ value: SavedScreenerParameter)

    @objc(removeSavedScreenerParameterObject:)
    @NSManaged public func removeFromSavedScreenerParameter(_ value: SavedScreenerParameter)

    @objc(addSavedScreenerParameter:)
    @NSManaged public func addToSavedScreenerParameter(_ values: NSSet)

    @objc(removeSavedScreenerParameter:)
    @NSManaged public func removeFromSavedScreenerParameter(_ values: NSSet)

}
