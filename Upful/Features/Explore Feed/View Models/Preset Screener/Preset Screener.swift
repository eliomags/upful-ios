//
//  Preset Screener.swift
//  Upful
//
//  Created by Yanik Simpson on 9/5/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct PresetScreenerViewModel {
    var presetScreener: PresetScreener
    
    var icon: UIImage {
        switch presetScreener.identifier {
        case .value1:
            return #imageLiteral(resourceName: "icons8-oak-tree-48").withRenderingMode(.alwaysOriginal)
        case .value2:
            return #imageLiteral(resourceName: "icons8-bonds-48").withRenderingMode(.alwaysOriginal)
        case .value3:
            return #imageLiteral(resourceName: "icons8-paper-money-48").withRenderingMode(.alwaysOriginal)
            
        case .dividend1:
            return #imageLiteral(resourceName: "icons8-paper-money-48").withRenderingMode(.alwaysOriginal)
        case .dividend2:
            return #imageLiteral(resourceName: "icons8-money-bag-48").withRenderingMode(.alwaysOriginal)
        case .dividend3:
            return #imageLiteral(resourceName: "icons8-account-48").withRenderingMode(.alwaysOriginal)
            
        case .growth1:
            return #imageLiteral(resourceName: "icons8-nut-48").withRenderingMode(.alwaysOriginal)
        case .growth2:
            return #imageLiteral(resourceName: "icons8-statistics-48").withRenderingMode(.alwaysOriginal)
        case .growth3:
            return #imageLiteral(resourceName: "icons8-oak-tree-48").withRenderingMode(.alwaysOriginal)
        }
    }
    
    init(presetScreener: PresetScreener) {
        self.presetScreener = presetScreener
        configureURL(presetScreener)
    }
    
    private mutating func configureURL(_ presetScreener: PresetScreener) {
        switch presetScreener.identifier {
            
        // MARK: - Value Data
        case .value1:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 20)
            self.presetScreener.createURLComponent(criteria: .pricetobook, parameter: .lt, 6)
            self.presetScreener.createURLComponent(criteria: .ebitmargin, parameter: .gt, 0.05)
        case .value2:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 25)
            self.presetScreener.createURLComponent(criteria: .pricetobook, parameter: .lt, 10)
            self.presetScreener.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.05)
            self.presetScreener.createURLComponent(criteria: .ebitmargin, parameter: .gt, 0.10)
        case .value3:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .pricetoearnings, parameter: .lt, 30)
            self.presetScreener.createURLComponent(criteria: .fcffgrowth, parameter: .gt, 0.10)
            self.presetScreener.createURLComponent(criteria: .ebitmargin, parameter: .lt, 0.4)
            
            // MARK: - Growth Data
        case .growth1:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.1)
            self.presetScreener.createURLComponent(criteria: .investedcapitalgrowth, parameter: .gt, 0.05)
        case .growth2:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.1)
            self.presetScreener.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 15)
        case .growth3:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.35)
            self.presetScreener.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 10)
            
            // MARK: - Dividend Data
        case .dividend1:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.02)
            self.presetScreener.createURLComponent(criteria: .divpayoutratio, parameter: .lt, 0.60)
        case .dividend2:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.00)
            self.presetScreener.createURLComponent(criteria: .revenuegrowth, parameter: .gt, 0.1)
            self.presetScreener.createURLComponent(criteria: .pricetorevenue, parameter: .lt, 15)
        case .dividend3:
            self.presetScreener.createURLComponent(criteria: .name, parameter: .gt, 0)
            self.presetScreener.createURLComponent(criteria: .dividendyield, parameter: .gt, 0.01)
            self.presetScreener.createURLComponent(criteria: .divpayoutratio, parameter: .lt, 0.50)
            self.presetScreener.createURLComponent(criteria: .epsgrowth, parameter: .gt, 0.1)
        }
    }
}
