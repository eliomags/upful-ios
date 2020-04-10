//
//  NotificationSetupPresenter.swift
//  Upful
//
//  Created by Yanik Simpson on 4/10/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

struct NotificationSetupPresenter {

    private static var didPresentNotificationSetup = false
    
    static func present(in vc: UIViewController) {
        if !didPresentNotificationSetup {
            UNUserNotificationCenter.current().getNotificationSettings {(notificationSettings) in
                if notificationSettings.authorizationStatus == .notDetermined {
                    didPresentNotificationSetup = true

                    DispatchQueue.main.async {
                        let notificationSetupVC = NotificationSetupViewController()
                        
                        guard var parentVC = vc.parent else {
                            vc.display(contentController: notificationSetupVC, on: vc.view)
                            return
                        }
                        
                        while let next = parentVC.parent { parentVC = next }
                        parentVC.display(contentController: notificationSetupVC, on: parentVC.view)
                    }
                }
                
                if notificationSettings.authorizationStatus == .authorized {
                    PermissionManager.shared.setupScreeningNotification()
                }
            }
        }
    }
}

extension UIViewController {
    func showNotificationSetupView() {
        NotificationSetupPresenter.present(in: self)
    }
}
