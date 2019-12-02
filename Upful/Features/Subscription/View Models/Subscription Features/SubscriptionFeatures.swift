//
//  SubscriptionFeatures.swift
//  Upful
//
//  Created by Yanik Simpson on 10/1/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct SubscriptionFeatureViewModel {
    let title: String
    let description: String
    let feature: FeatureType
    
    enum FeatureType {
        case saving
        case screens
        case notes
    }
    
    var image: UIImage {
        let config = UIImage.SymbolConfiguration.init(pointSize: 30, weight: .bold)
        switch feature {

        case .saving:
            let im = UIImage(systemName: "heart.fill", withConfiguration: config)?
                .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
            return im!
            
        case .screens:
            let im = UIImage(systemName: "chart.bar.fill", withConfiguration: config)?
                .withTintColor(.appAccent3, renderingMode: .alwaysOriginal)
            return im!

        case .notes:
            return #imageLiteral(resourceName: "icons8-create-30").withRenderingMode(.alwaysOriginal)
        }
    }

    
    init(subscriptionFeature: SubscriptionFeature, feature: FeatureType) {
        self.title = subscriptionFeature.title
        self.description = subscriptionFeature.description
        self.feature = feature
    }
    
}
