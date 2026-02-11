//
//  AnalyticsMapper.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

final class AnalyticsLogger {
    enum AnalyticsDefaults {
        static let allowTracking = "allowTracking"
    }
    static let instance = AnalyticsLogger()
    
    private let mixpanelAnalytics = MixPanelAnalytics()
    private let googleAnalytics = FirebaseAnalytics()
    
    private var isTrackingDisabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: AnalyticsDefaults.allowTracking)
        }
        get {
            return UserDefaults.standard.bool(forKey: AnalyticsDefaults.allowTracking)
        }
    }
    
    // MARK: - API

    func getAnalyticsPermission() -> Bool {
        return !isTrackingDisabled
    }
    
    func toggleAnalytics() {
        isTrackingDisabled = !isTrackingDisabled
    }
    
    func reportEvents(event: AnalyticsEventName) {
        guard !isTrackingDisabled else { return }
            #if RELEASE
                let analyticsAPIs: [AnalyticsTracker] = [mixpanelAnalytics, googleAnalytics]
                analyticsAPIs.forEach { (analyticsItem) in
                    analyticsItem.log(event: event)
                }
            
            #elseif DEBUG
                print("Logged event for:", event)

            #endif
    }
}













