//
//  PersistenceService.swift
//  Upful
//
//  Created by Yanik Simpson on 9/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    static let shared = PersistenceService()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /// Load the container associated with the app
        let container = NSPersistentContainer(name: "StockDataModel")
        
        /// Loads the saved Database if it exists or creates it.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                print("Unresolved error", error.localizedDescription)
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContextWithCompletion(completion: ()-> Void) {
        self.saveContext()
        completion()
    }

}



