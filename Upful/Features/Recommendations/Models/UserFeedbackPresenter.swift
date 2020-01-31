//
//  AppStoreReviewHelper.swift
//  Upful
//
//  Created by Yanik Simpson on 9/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import StoreKit

struct UserFeedbackPresenter {
    enum AppStoreReviewKeys: String {
        case appOpenCount
        case detailSessionCount
        case hasSubmittedReview
    }

    private static func incrementUserAppSessionCount() {
        guard var appOpenCount = UserDefaults.standard.value(forKey: AppStoreReviewKeys.appOpenCount.rawValue) as? Int else {
            UserDefaults.standard.set(1, forKey: AppStoreReviewKeys.appOpenCount.rawValue)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: AppStoreReviewKeys.appOpenCount.rawValue)
    }
    
    private static func incrementImportantActionCount() {
        guard var detailSessionCount = UserDefaults.standard.value(forKey: AppStoreReviewKeys.detailSessionCount.rawValue) as? Int else {
            UserDefaults.standard.set(1, forKey: AppStoreReviewKeys.detailSessionCount.rawValue)
            return
        }
        detailSessionCount += 1
        UserDefaults.standard.set(detailSessionCount, forKey: AppStoreReviewKeys.detailSessionCount.rawValue)
    }
    
    enum CheckType {
        case newSession
        case importantAction
    }
    
    static func checkAndAskForReview(checkType: CheckType,in vc: UIViewController) {
        switch checkType {
        case .newSession:
            UserFeedbackPresenter.incrementUserAppSessionCount()
            
            guard let appOpenCount = UserDefaults.standard.value(forKey: AppStoreReviewKeys.appOpenCount.rawValue) as? Int else {
                UserDefaults.standard.set(1, forKey: AppStoreReviewKeys.appOpenCount.rawValue)
                return
            }
            switch appOpenCount {
            case 10,25:
                show(in: vc)
            case _ where appOpenCount%100 == 0:
                show(in: vc)
            default:
                break
            }
        case .importantAction:
            UserFeedbackPresenter.incrementImportantActionCount()
            
            guard let detailSessionCount = UserDefaults.standard.value(forKey: AppStoreReviewKeys.detailSessionCount.rawValue) as? Int else {
                UserDefaults.standard.set(1, forKey: AppStoreReviewKeys.detailSessionCount.rawValue)
                return
            }
            switch detailSessionCount {
            case 4,35:
                show(in: vc)
            case _ where detailSessionCount%60 == 0:
                show(in: vc)
            default:
                break
            }
        }
    }
    
    static func show(in vc: UIViewController) {
        if UserDefaults.standard.bool(forKey: AppStoreReviewKeys
            .hasSubmittedReview.rawValue) {
            requestAppStoreReview()
        } else {
            let navVC = UINavigationController(rootViewController: RecommendationViewController())
            navVC.modalPresentationStyle = .fullScreen
            vc.present(navVC, animated: true, completion: nil)
        }
    }

    static func requestAppStoreReview() {
        SKStoreReviewController.requestReview()
    }
}

