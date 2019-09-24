//
//  SavedStock+CoreDataProperties.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedStock {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<SavedStock> {
        return NSFetchRequest<SavedStock>(entityName: "SavedStock")
    }

    @NSManaged public var notes: String
    @NSManaged public var ticker: String
    @NSManaged public var companyName: String

}
