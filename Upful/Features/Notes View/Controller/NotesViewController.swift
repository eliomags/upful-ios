//
//  NotesViewController.swift
//  Upful
//
//  Created by Yanik Simpson on 9/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol NoteVCDelegate: UIViewController {
    func displaySuccessNote()
}

class NotesViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: NoteVCDelegate?
    
    let viewModel = NotesViewModel()
    
    // MARK: - Views
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.delegate = self
        textView.backgroundColor = UIColor(white: 0.96, alpha: 1)
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
        view.backgroundColor = .white
        setupNavBar()
        setupTextView()
        getNotes()
    }
    
    // MARK: - View Setup
    lazy var cancelButton: CancelButton = {
        let button = CancelButton()
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissTap)))
        return button
    }()
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Notes"
        navigationController?.navigationBar.tintColor = .appAccent3
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDoneTap))
    }
    
    fileprivate func setupTextView() {
        view.addSubview(textView)
        textView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    
    // MARK: - Delegate Methods
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.addNoteText(textView.text ?? "")
    }
    
    // MARK: - Helpers
    
    private func handleLoadFailure(completion: (()->())) {
        InformationViewPresenter.displayErrorActionView(in: self, message: "Error fetching")
        completion()
    }
    
    private func getNotes() {
        do {
            try viewModel.loadNotes()
            textView.text = viewModel.noteText
        } catch {
            handleLoadFailure {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions

    @objc private func handleDismissTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneTap(_ sender: UIBarButtonItem) {
        viewModel.saveNotes {
            self.dismiss(animated: true, completion: {
                self.delegate?.displaySuccessNote()
            })
        }
    }
    
}
