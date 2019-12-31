//
//  Array+Extensions.swift
//  Upful
//
//  Created by Yanik Simpson on 12/20/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    mutating func moveItem(from source: Int, to destination: Int) {
        let item = self[source]
        self.remove(at: source)
        self.insert(item, at: destination)
    }
    
    mutating func removeDuplicates() {
        self = Array(Set(self))
    }
}
