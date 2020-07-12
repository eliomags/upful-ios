//
//  ChartUpdatable.swift
//  Upful
//
//  Created by Yanik Simpson on 9/19/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

enum ChartType {
    case bar, line
}

protocol ChartTypeUpdatable: class {
    func updateChartData(chartType: ChartType, criteria: SearchCriteria)
}

protocol ChartSearchCriteriaSelectionDelegate: class {
    func didChangeSearchCriteria(previousSearchCriteria: SearchCriteria, updatedSearchCriteria: SearchCriteria)
}
