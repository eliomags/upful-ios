//
//  ReportPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 10/7/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

protocol ReportDelegate: class { }
extension SettingsViewController: ReportDelegate {}


struct ReportPresenter {
    enum ReportType {
        case suggestion, issue
    }
    
    let reportType: ReportType
    
    func present(in viewController: UIViewController) {
        var title = ""
        var reportInstructions = ""
        
        switch reportType {
        case .issue:
            title = "Report Issue"
            reportInstructions = "Issue:"
            
            let reportViewController = IssueViewController(title: title,
                                                            reportInstructions: reportInstructions)
            reportViewController.delegate = viewController as? ReportDelegate
            
            let navVC = UINavigationController(rootViewController: reportViewController)
            viewController.present(navVC, animated: true, completion: nil)

        case .suggestion:
            title = "Send Suggestion"
            reportInstructions = "Suggestion:"
            
            let reportViewController = SuggestionViewController(title: title,
                                                            reportInstructions: reportInstructions)
            reportViewController.delegate = viewController as? ReportDelegate
            
            let navVC = UINavigationController(rootViewController: reportViewController)
            viewController.present(navVC, animated: true, completion: nil)
        }
    }
}
