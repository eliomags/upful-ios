//
//  ManualScreenItemViewModel.swift
//  Upful
//
//  Created by Yanik Simpson on 4/8/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct ManualScreenItemViewModel {
    
    var manualScreenItem: ManualScreenItem
    var isSelected: Bool {
        return !(manualScreenItem.parameter == .none)
    }
    var titleText: String {
        return manualScreenItem.criteria.explicit
    }
    var descritionText: String {
        if manualScreenItem.parameter == .none {
            return ""
        } else {
            return manualScreenItem.parameter.explicit
        }
    }
    var value: Float?
    
    init(manualScreenItem: ManualScreenItem) {
        self.manualScreenItem = manualScreenItem
    }
}
