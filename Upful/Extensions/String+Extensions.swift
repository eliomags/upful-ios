//
//  String+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 8/31/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension String {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self)
        
        formatter.dateFormat = "yyyy"
        let newdate = formatter.string(from: date ?? Date())
        
        return newdate
    }
}
