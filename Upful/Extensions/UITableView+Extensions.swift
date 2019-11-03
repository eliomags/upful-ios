//
//  UITableView+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/21/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

// MARK: - Get TableView Content Height for non scrollable display view

extension UITableView {
    func contentHeight() -> CGFloat {
        var height = CGFloat(0)
        for sectionIndex in 0..<numberOfSections {
            height += rect(forSection: sectionIndex).size.height
        }
        return height
    }
}

// MARK: - TableView state for data

enum TableViewState {
    case errorState
    case emptyState(title: String, message: String)
    
    var stateTitle: String {
        switch self {
        case .errorState:
            return "Error."
        case .emptyState (let title):
            return title.title
        }
    }
    
    var stateMessage: String {
        switch self {
        case .errorState:
            return "Failed to send request to server."
        case .emptyState (let message):
            return message.message
        }
    }
    
    var stateImage: UIImage {
        switch self {
        case .errorState:
            return #imageLiteral(resourceName: "icons8-sad-cloud-50 (1).png").withRenderingMode(.alwaysOriginal)
        case .emptyState:
            return UIImage()
//            return #imageLiteral(resourceName: "icons8-sad-50.png").withRenderingMode(.alwaysOriginal)
        }
    }
}

extension UITableView {
    func setEmptyView(state: TableViewState) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let stateImageView = UIImageView()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .viewHeader
        titleLabel.textAlignment = .center
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = .details1
        messageLabel.textAlignment = .center
        
        stateImageView.image = state.stateImage
        stateImageView.backgroundColor = .clear
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(stateImageView)
        
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -150).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        
        stateImageView.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor).isActive = true
        stateImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15).isActive = true

        titleLabel.text = state.stateTitle
        messageLabel.text = state.stateMessage
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}


// MARK: - Setting and Updating TableView Header View

extension UITableView {
    // 1.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView = headerView
        // ** Must setup AutoLayout after set tableHeaderView.
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    // 2.
    func shouldUpdateHeaderViewFrame() -> Bool {
        guard let headerView = self.tableHeaderView else { return false }
        let oldSize = headerView.bounds.size
        // Update the size
        headerView.layoutIfNeeded()
        let newSize = headerView.bounds.size
        return oldSize != newSize
    }
}
/*
 The gist is that you should let tableView manage the frame of tableHeaderView the same way as table view cells. This is done through tableView's beginUpdates/endUpdates.

 The thing is that tableView doesn't care about AutoLayout when it updates the children frames. It uses the current tableHeaderView's size to determine where the first cell/section header should be.

 1) Add a width constraint so that the tableHeaderView uses this width whenever we call layoutIfNeeded(). Also add centerX and top constraints to position it correctly relative to the tableView.

 2) To let the tableView knows about the latest size of tableHeaderView, e.g., when the device is rotated, in viewDidLayoutSubviews we can call layoutIfNeeded() on tableHeaderView. Then, if the size is changed, call beginUpdates/endUpdates.
 */




