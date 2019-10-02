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
    var image: UIImage
    
    
    init(subscriptionFeature: SubscriptionFeature) {
        self.title = subscriptionFeature.title
        self.description = subscriptionFeature.description
        self.image = #imageLiteral(resourceName: "icons8-account-48").withRenderingMode(.alwaysOriginal)
    }
    
}
