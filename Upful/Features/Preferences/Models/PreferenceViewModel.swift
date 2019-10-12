//
//  PreferenceViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 10/11/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

struct PreferenceViewModel {
    let description: String
    let criteria: SearchCriteria
    let parameter: SearchParameter
    let value: String
    let id: PreferenceID
    
    init(preference: Preference) {
        self.description = preference.description
        self.criteria = preference.criteria
        self.parameter = preference.parameter
        self.value = preference.value
        self.id = preference.id
    }
}

extension PreferenceViewModel {
    var icon: UIImage? {
        switch id {
        case .industryRetail:
            return #imageLiteral(resourceName: "icons8-shop-25").withRenderingMode(.alwaysOriginal)
        case .industryDrug:
            return #imageLiteral(resourceName: "icons8-syringe-25").withRenderingMode(.alwaysOriginal)
        case .industryFinancialServices:
            return #imageLiteral(resourceName: "icons8-bank-building-25").withRenderingMode(.alwaysOriginal)
        case .industryBanking:
            return #imageLiteral(resourceName: "icons8-bank-building-25").withRenderingMode(.alwaysOriginal)
        case .industryRealEstate:
            return #imageLiteral(resourceName: "icons8-shop-25").withRenderingMode(.alwaysOriginal)
        case .insurance:
            return #imageLiteral(resourceName: "icons8-vehicle-insurance-25").withRenderingMode(.alwaysOriginal)
        case .industryHealthServices:
            return #imageLiteral(resourceName: "icons8-syringe-25").withRenderingMode(.alwaysOriginal)
        case .computerSoftware:
            return #imageLiteral(resourceName: "icons8-laptop-25").withRenderingMode(.alwaysOriginal)
        case .computerHardware:
            return #imageLiteral(resourceName: "icons8-laptop-25").withRenderingMode(.alwaysOriginal)
        case .electronics:
            return #imageLiteral(resourceName: "icons8-laptop-25").withRenderingMode(.alwaysOriginal)
        case .consumerNonDurable:
            return #imageLiteral(resourceName: "icons8-ingredients-25").withRenderingMode(.alwaysOriginal)
        case .wholesale:
            return #imageLiteral(resourceName: "icons8-shop-25").withRenderingMode(.alwaysOriginal)
        case .foodBeverage:
            return #imageLiteral(resourceName: "icons8-vegetarian-food-25").withRenderingMode(.alwaysOriginal)
        case .manufacturing:
            return #imageLiteral(resourceName: "icons8-robot-25").withRenderingMode(.alwaysOriginal)
        case .telecommunications:
            return #imageLiteral(resourceName: "icons8-radio-tower-25").withRenderingMode(.alwaysOriginal)
        case .energy:
            return #imageLiteral(resourceName: "icons8-electricity-25").withRenderingMode(.alwaysOriginal)
        case .utilities:
            return #imageLiteral(resourceName: "icons8-water-25").withRenderingMode(.alwaysOriginal)
        case .media:
            return #imageLiteral(resourceName: "icons8-news-25").withRenderingMode(.alwaysOriginal)
        case .leisure:
            return #imageLiteral(resourceName: "icons8-surfing-25").withRenderingMode(.alwaysOriginal)
        case .automotive:
            return #imageLiteral(resourceName: "icons8-suv-25").withRenderingMode(.alwaysOriginal)
        case .transportation:
            return #imageLiteral(resourceName: "icons8-train-25").withRenderingMode(.alwaysOriginal)
        case .defense:
            return #imageLiteral(resourceName: "icons8-fighter-jet-25").withRenderingMode(.alwaysOriginal)
        default:
            return nil
        }
    }
}

