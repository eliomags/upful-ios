//
//  GoogleAnalytics.swift
//  Upful
//
//  Created by Yanik Simpson on 8/25/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation
import Firebase


class FirebaseAnayltics: AnalyticsTracker {
    
    init() {}
    
    func log(event: AnalyticsEventName) {
        Analytics.logEvent(event.getName(),
                           parameters: event.parameters)
    }
}











