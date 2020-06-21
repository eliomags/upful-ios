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

extension CoreDataModelContainerManager {
    func saveContext(completion: (() -> Void)?) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion?()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
