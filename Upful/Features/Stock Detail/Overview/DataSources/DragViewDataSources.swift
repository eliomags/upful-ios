//
//  DragViewDataSources.swift
//  Upful
//
//  Created by Yanik Simpson on 7/19/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
import YSDraggy

protocol StockDetailDragViewPresentable: DragControllerDataSource {
    typealias MetricCellTapAction = ((Int) -> Void)
    var cellTapAction: MetricCellTapAction? { get set }
    
    var viewModels: [MetricPreviewViewModel] { get set }
    var footerView: ((UIView) -> UIView)? { get set }
    var headerDisplay: (([MetricPreviewViewModel]) -> UIView?)? { get set }
}

class EmptyStockMetricDataSource: NSObject, StockDetailDragViewPresentable {
    
    var headerDisplay: (([MetricPreviewViewModel]) -> UIView?)?
    var footerView: ((UIView) -> UIView)?
    
    var viewModels = [MetricPreviewViewModel]()
    var cellTapAction: MetricCellTapAction?
    
    weak var controller: DragControllerStateManager?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleStateChange(scrollView: scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return footerView?(view)
    }
}

class StockMetricDisplayDataSource: NSObject, StockDetailDragViewPresentable {
    
    var headerDisplay: (([MetricPreviewViewModel]) -> UIView?)?
    var footerView: ((UIView) -> UIView)?
    
    var viewModels = [MetricPreviewViewModel]()
    var cellTapAction: MetricCellTapAction?
    
    weak var controller: DragControllerStateManager?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleStateChange(scrollView: scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MetricPreviewTableViewCell.reuseID, for: indexPath)
            as? MetricPreviewTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = VersionManager.collectionCellColor3()
        let metricViewModel = viewModels[indexPath.row]
        metricViewModel.configureCell(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTapAction?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerDisplay?(viewModels)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return footerView?(view)
    }
}

class MetricAnalysisDataSource: NSObject, StockDetailDragViewPresentable {
    
    var headerDisplay: (([MetricPreviewViewModel]) -> UIView?)?
    var footerView: ((UIView) -> UIView)?
    
    var viewModels = [MetricPreviewViewModel]()
    var cellTapAction: MetricCellTapAction?
    
    weak var controller: DragControllerStateManager?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleStateChange(scrollView: scrollView)
    }
    
    enum Rows: Int, CaseIterable {
        case chart
        case metricOne
        case metricTwo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == Rows.chart.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AnalysisChartCell.reuseID, for: indexPath)
                as? AnalysisChartCell else { return UITableViewCell() }
            if let firstVM = viewModels.first, let secondVM = viewModels.last {
                guard !firstVM.historicalData.isEmpty else { return cell }
                let firstVMValues = firstVM.historicalData.map { $0.value }
                let secondVMValues = secondVM.historicalData.map { $0.value }
                let firstVMDates = firstVM.historicalData.map { $0.date.formatDate() }
                let secondVMDates = secondVM.historicalData.map { $0.date.formatDate() }
                cell.chartView.generateBarData(dataPoints: secondVMDates, values: secondVMValues, criteria: secondVM.searchCriteria)
                cell.chartView.generateLineData(dataPoints: firstVMDates, values: firstVMValues, criteria: firstVM.searchCriteria)
            }
            return cell
        } else
            if row == Rows.metricOne.rawValue || row == Rows.metricTwo.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MetricSelectionTableViewCell.reuseID, for: indexPath)
                as? MetricSelectionTableViewCell {
                let criteria = viewModels[row-1].searchCriteria
                cell.titleLabel.text = criteria.explicit
                cell.iconView.backgroundColor = row == 1 ? .appAccent : .appAccent3
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case Rows.chart.rawValue:
            return 245
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Rows.chart.rawValue { return }
        cellTapAction?(indexPath.row-1)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return footerView?(view)
    }
}
