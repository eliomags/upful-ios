//
//  NotesViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol NoteVCDelegate: class {
    func displaySuccessNote()
}

class NotesViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: NoteVCDelegate?
    
    var noteText = String() {
        didSet {
            textView.text = noteText
        }
    }
    
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.delegate = self
        textView.backgroundColor = .white
        textView.text = ""
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.textColor = .darkText
        return textView
    }()
    
    
    // MARK: - Initializer Methods
    
    init(delegate: NoteVCDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(textView)
        textView.anchor(
            top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        setupNavBar()
        loadNotes()
    }
    
    
    // MARK: - View Setup
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Notes"
        navigationController?.navigationBar.tintColor = .appAccent
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDoneTap))
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        noteText = textView.text ?? ""
    }
    
    
    // MARK: - Core Data
    
    private func handleLoadFailure(completion: (()->())) {
        InformationViewPresenter.displayErrorActionView(in: self, message: "Error fetching")
        completion()
    }
    
    private func loadNotes() {
        let request = Notes.createfetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "1")
        do {
            let notes = try PersistenceService.shared.persistentContainer.viewContext.fetch(request)
            noteText = notes.compactMap({ $0.content }).last ?? "Start adding notes."
        } catch {
            handleLoadFailure {
                print(error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// This is actually creating a new notes object and persisting that
    private func saveNotes(completion: (()->())) {
        let notes = Notes(context: PersistenceService.shared.persistentContainer.viewContext)
        notes.content = noteText
        notes.id = "1"
        PersistenceService.shared.saveContextWithCompletion {
            completion()
        }
    }
    
    @objc private func handleDismissTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneTap(_ sender: UIBarButtonItem) {
        saveNotes {
            self.dismiss(animated: true, completion: {
                self.delegate?.displaySuccessNote()
            })
        }
    }
    
}
