//
//  Constants.swift
//  Upful
//
//  Created by Yanik Simpson on 9/2/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

let https = "https"

public struct Constants {
    struct MixPanel {
        static let token = Secrets.mixpanelToken
    }

    struct Intrinio {
        static let apiKey = Secrets.intrinioApiKey
    }
    struct IEXTrading {
        static let productionKey = Secrets.iexProductionKey
        static let sandboxKey = Secrets.iexSandboxKey
        static let appendingProductionKey = Secrets.iexAppendingProductionKey

        struct EndPoints {
            static let sandbox = "https://sandbox.iexapis.com/stable/stock/"
            static let production = "https://cloud.iexapis.com/stable/stock/"
        }
    }

    struct Legal {
        static let privacyPolicy = "https://app.termly.io/document/privacy-policy/75ab3001-a1a2-42a9-afce-443837abfbac"
        static let termsOfUse = "https://app.termly.io/document/terms-of-use-for-saas/b1adf4c2-6320-4de7-acbc-d702d7ed4c1a"
    }

    struct StockNewsAPI {
        static let token = Secrets.stockNewsApiToken
    }

    struct SharedUserDefaults {
        static let firstAppOpen = "firstAppOpen"
    }
}
