//
//  Secrets.example.swift
//  Upful
//
//  INSTRUCTIONS: Copy this file to Secrets.swift and fill in your API keys.
//  Secrets.swift is git-ignored and will not be committed.
//

import Foundation

struct Secrets {
    // Mixpanel Analytics
    static let mixpanelToken = "YOUR_MIXPANEL_TOKEN"

    // Intrinio Financial Data
    static let intrinioApiKey = "&api_key=YOUR_INTRINIO_API_KEY"

    // IEX Cloud
    static let iexProductionKey = "?token=YOUR_IEX_PRODUCTION_KEY"
    static let iexSandboxKey = "?token=YOUR_IEX_SANDBOX_KEY"
    static let iexAppendingProductionKey = "&token=YOUR_IEX_PRODUCTION_KEY"

    // Stock News API
    static let stockNewsApiToken = "YOUR_STOCK_NEWS_API_TOKEN"

    // IAP Shared Secret
    static let iapSharedSecret = "YOUR_IAP_SHARED_SECRET"
}
