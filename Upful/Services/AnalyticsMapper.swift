//
//  AnalyticsMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation


final class AnalyticsLogger {
    static let mixpanelAnalytics = MixPanelAnalytics()
    static let googleAnalytics = FirebaseAnayltics()
    
    static func reportEvents(event: AnalyticsEventName) {
        let analyticsAPIs: [AnalyticsTracker] = [mixpanelAnalytics, googleAnalytics]
        
        analyticsAPIs.forEach { (analytics) in
//            analytics.log(event: event)
            print("Logged event for:", event, analytics)
        }
    }
}













