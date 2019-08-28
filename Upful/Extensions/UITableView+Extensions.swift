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
    case emptyState
    
    var stateTitle: String {
        switch self {
        case .errorState:
            return "Error."
        case .emptyState:
            return "No stocks found."
        }
    }
    
    var stateMessage: String {
        switch self {
        case .errorState:
            return "Failed to send request to server."
        case .emptyState:
            return "There is no data to display."
        }
    }
    
    var stateImage: UIImage {
        switch self {
        case .errorState:
            return #imageLiteral(resourceName: "icons8-sad-cloud-50 (1).png").withRenderingMode(.alwaysOriginal)
        case .emptyState:
            return #imageLiteral(resourceName: "icons8-sad-50.png").withRenderingMode(.alwaysOriginal)
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
        
        titleLabel.textColor = UIColor.black
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
        self.separatorStyle = .singleLine
    }
}








