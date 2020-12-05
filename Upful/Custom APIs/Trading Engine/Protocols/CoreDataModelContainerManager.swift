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
    func saveOrRollBackIfNeeded(completion: ((Error?) -> Void)) {
        if hasChanges {
            do {
                try save()
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
}
