//
//  Notes+CoreDataProperties.swift
//  Upful
//
//  Created by Yanik Simpson on 9/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var content: String
    @NSManaged public var id: String

}
