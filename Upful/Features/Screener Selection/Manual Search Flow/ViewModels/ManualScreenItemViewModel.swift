//
//  ManualScreenItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

class ManualScreenItemViewModel {
    
    var manualScreenItem: ManualScreenItem

    var isSelected: Bool {
        return !(descriptionText.isEmpty)
    }
    var titleText: String {
        return manualScreenItem.criteria.explicit
    }
    var descriptionText: String {
        if manualScreenItem.parameter != .none {
            if manualScreenItem.criteria.parameterType == .percentage {
                return manualScreenItem.parameter.explicit + " " + "\(manualScreenItem.value!.convertToPercent())%"
            }
            if manualScreenItem.criteria.parameterType == .ratio {
                return manualScreenItem.parameter.explicit + " " + String(Int(manualScreenItem.value!))
            }
            if manualScreenItem.criteria.parameterType == .number {
                return manualScreenItem.parameter.explicit + " $" + Int(manualScreenItem.value!).formatUsingAbbreviation()
            }
        } 
        return ""
    }
    
    init(manualScreenItem: ManualScreenItem) {
        self.manualScreenItem = manualScreenItem
    }
    
    func resetParameter() {
        manualScreenItem.parameter = .none
        manualScreenItem.value = nil
    }
}
