//
//  DragViewDataSources.swift
//  Upful
//
//  Created by Yanik Simpson on 7/19/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit
// import YSDraggy // REMOVED: Package removed during rebuild - replaced by SwiftUI sheets

class EmptyStockMetricDataSource: NSObject, DragControllerDataSource {
    
    weak var delegate: AnalysisDragContentDelegate?
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
        return delegate?.createTradeButtonFooterView(in: view, topPadding: 4)
    }
}

class MetricPreviewDataSource: NSObject, DragControllerDataSource {
    
    weak var delegate: MetricPreviewDataSourceDelegate?
    weak var controller: DragControllerStateManager?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleStateChange(scrollView: scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        return delegate?.createMetricPreviewCell(tableView, at: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectMetricPreviewCell(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return delegate?.createMetricPreviewHeader(in: view)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return delegate?.createTradeButtonFooterView(in: view, topPadding: 12)
    }
}

final class MetricAnalysisDataSource: NSObject, DragControllerDataSource {
    
    enum AnalysisRows: Int, CaseIterable {
        case chart
        case metricOne
        case metricTwo
    }
        
    weak var delegate: AnalysisCompareDataSourceDelegate?
    weak var controller: DragControllerStateManager?
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleStateChange(scrollView: scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnalysisRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == AnalysisRows.chart.rawValue {
            return delegate?.createAnalysisChartCell(tableView, at: indexPath) ?? UITableViewCell()
            
        } else {
            if row == AnalysisRows.metricOne.rawValue || row == AnalysisRows.metricTwo.rawValue {
                return delegate?.createMetricSelectionCell(tableView, at: indexPath) ?? UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
        case AnalysisRows.chart.rawValue:
            return 245
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == AnalysisRows.chart.rawValue { return }
        delegate?.didSelectMetricPreviewCell(at: indexPath.row-1)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return delegate?.createTradeButtonFooterView(in: view, topPadding: 12)
    }
}
