//
//  SavedScreenerParameter+CoreDataProperties.swift
//  Upful
//
//  Created by Yanik Simpson on 9/22/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedScreenerParameter {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<SavedScreenerParameter> {
        return NSFetchRequest<SavedScreenerParameter>(entityName: "SavedScreenerParameter")
    }

    @NSManaged public var criteria: String
    @NSManaged public var parameter: String
    @NSManaged public var value: Double
    @NSManaged public var screener: String?
    @NSManaged public var savedScreener: SavedScreener?

}
