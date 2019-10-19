//
//  NotesViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 10/16/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import CoreData

class NotesViewModel {
    // MARK: - Dependencies
    
    var noteText = String()
    
    // MARK: - Initialze
    
    init() {
    }
    
    func addNoteText(_ text: String) {
        noteText = text
    }
    
    // MARK: - Core Data
    
    func loadNotes() throws {
        let request = Notes.createfetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "1")
        do {
            let notes = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            noteText = notes.compactMap({ $0.content }).last ?? "Start adding notes."
        }
    }
    
    func saveNotes(completion: (()->())) {
        AnalyticsLogger.instance.reportEvents(event: .noteSaved(description: noteText))

        let notes = Notes(context: PersistenceService.shared.persistentContainer.viewContext)
        notes.content = noteText
        notes.id = "1"
        PersistenceService.shared.saveContextWithCompletion {
            completion()
        }
    }
    
}
