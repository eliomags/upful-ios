//
//  Suggestions.swift
//  Upful
//
//  Created by Yanik Simpson on 11/28/19.
//  Copyright © 2019 Yanik Simpson. All rights reserved.
//

import Foundation

class Suggestion {
    let title: String
    let description: String
    var votes: Int
    
    init(title: String, description: String, votes: Int) {
        self.title = title
        self.description = description
        self.votes = votes
    }
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.votes = dictionary["votes"] as? Int ?? 0
    }
}

