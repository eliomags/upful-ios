//
//  UpfulDeepLinkManager.swift
//  Upful
//
//  Created by Yanik Simpson on 10/23/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
// import FirebaseFirestore // REMOVED: Firebase removed during rebuild
// import FirebaseDynamicLinks // REMOVED: Firebase removed during rebuild

class UpfulDeepLinkManager {
    enum AppRoute: String {
        case company
        case screener
    }
    
    private static let db = Firestore.firestore()
    
    static func route(from vc: UIViewController?, incomingURL: URL) {
        let route = incomingURL.path.replacingOccurrences(of: "/", with: "")
        guard let appRoute = AppRoute(rawValue: route) else {
            print("attempting to route ::", incomingURL)
            return
        }
        
        switch appRoute {
        case .company:
            let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: false)!
            let queryItems = components.queryItems!
            var sentFromID = ""
            var sentTicker = ""
            for queryItem in queryItems {
                if queryItem.name == "ticker" {
                    sentTicker = queryItem.value ?? "FB"
                } else if queryItem.name == "senderid" {
                    sentFromID = queryItem.value ?? "error"
                }
            }
            
            if UserDefaults.standard.firstAppOpen {
                db.collection("users").document(sentFromID).collection("recruits")
                    .addDocument(data: ["user": UserProfile.instance.profileID], completion: nil)
            } else {
                print("Not my first rodeo ;-)", sentFromID)
            }
            StockDetailsCoordinator(
                presenter: vc!,
                stockViewModel: .init(stock: .init(name: "", ticker: sentTicker.uppercased()))
            ).start()
            
        case .screener:
            break
        }
    }
    
    static func create(companyname: String, ticker: String, completionHandler: @escaping (URL) -> Void) {
        var components = URLComponents()
        components.scheme = https
        components.host = AppInfo.upfulURLHost
        components.path = "/\(AppRoute.company.rawValue)"
        let tickerQueryItem = URLQueryItem(name: "ticker", value: ticker)
        let senderID = URLQueryItem(name: "senderid", value: UserProfile.instance.profileID)
        components.queryItems = [tickerQueryItem, senderID]
        
        let shareLink = DynamicLinkComponents(link: components.url!, domainURIPrefix: AppInfo.upfulURLFull)
        shareLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: AppInfo.bundleID)
        shareLink?.iOSParameters?.appStoreID = AppInfo.appStoreID
        shareLink?.socialMetaTagParameters?.imageURL = AppInfo.appPreviewImageURL
        shareLink?.socialMetaTagParameters?.title = "\(ticker) on Upful!"
        shareLink?.socialMetaTagParameters?.descriptionText = "Start paper trading \(ticker) and stocks like this on Upful!"
        
        let longURL = shareLink?.url ?? URL(string: "https://upful.io/company/ticker=\(ticker)&senderid=\(UserProfile.instance.profileID)")!
        print("long url:", longURL)
        
        shareLink?.shorten(completion: { (url, warnings, error) in
            if let error = error {
                print("encountered an error while shortening link \(shareLink?.url?.absoluteString ?? ""), \(error.localizedDescription)")
            }
            warnings?.forEach({ warning in
                print("FDL Warning", warning)
            })

            if let url = url {
                print(url)
                completionHandler(url)
            }
        })
    }
}

struct AppInfo {
    static let bundleID = Bundle.main.bundleIdentifier ?? "com.syanik.Upful"
    static let appStoreID = "1447909027"
    static let upfulURLHost = "upful.io"
    static let upfulURLFull = "https://upful.io"
    static let appPreviewImageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/upful-c9f8c.appspot.com/o/image1%205.png?alt=media&token=6b8131c7-dbd8-4390-8a1c-d25b0c546580")!
}
