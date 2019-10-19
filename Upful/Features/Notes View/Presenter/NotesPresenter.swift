//
//  NotesPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/17/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct NotesPresenter {
    func present(in viewController: NoteVCDelegate) {
        let notesVC = NotesViewController(delegate: viewController)
        let navVC = UINavigationController(rootViewController: notesVC)
        viewController.present(navVC, animated: true, completion: nil)
    }
}
