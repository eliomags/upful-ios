//
//  CoreDataModelContainerManager.swift
//  Upful
//
//  Created by Yanik Simpson on 3/15/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataModelContainerManager {
    var persistentContainer: NSPersistentContainer { get set }
}

extension NSManagedObjectContext {
    func saveOrRollBackIfNeeded() {
        if hasChanges {
            do {
                try save()
            } catch {
                rollback()
            }
        }
    }
}
