//
//  UITableViewCell+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 10/24/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func addBottomSeparator() {
        let separator = SpacerView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(separator)
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
