//
//  GoogleAnalytics.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase
import Mixpanel

protocol AnalyticsTracker {
    func log(event: AnalyticsEventName)
}


struct MixPanelAnalytics: AnalyticsTracker {
    func log(event: AnalyticsEventName) {
        Mixpanel.mainInstance().track(event: event.getName(),
                                      properties: event.metaData)
    }
}

struct FirebaseAnayltics: AnalyticsTracker {
    func log(event: AnalyticsEventName) {
        Analytics.logEvent(event.getName(),
                           parameters: event.metaData)
    }
}












