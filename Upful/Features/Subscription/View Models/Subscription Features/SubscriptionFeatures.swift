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
        switch feature {
            
        case .saving:
            return #imageLiteral(resourceName: "icons8-star-30 (2)").withRenderingMode(.alwaysOriginal)
            
        case .screens:
            return #imageLiteral(resourceName: "icons8-sales-performance-48").withRenderingMode(.alwaysOriginal)

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
