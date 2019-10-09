//
//  SubscriptionProtocols.swift
//  Upful
//
//  Created by Yanik Simpson on 10/9/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

protocol SubscriptionFeatureDataSource: class {
    var subscriptionOfferings: [SubscriptionFeatureViewModel] { get set }
}
