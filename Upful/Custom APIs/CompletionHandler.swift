//
//  CompletionHandler.swift
//  Upful
//
//  Created by Yanik Simpson on 8/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct CompletionHandler<T> {
    private var id = UUID().uuidString
    
    private(set) var block: ((T?) -> Void)
    
    init(_ block: @escaping ((T?) -> Void) = { _ in }) {
        self.block = block
    }
    
    mutating func subscribe(_ block: @escaping ((T?) -> Void)) {
        self.block = block
    }
    
    mutating func unsubscribe() {
        self.block = { _ in }
    }
    
    func notify(_ sender: T? = nil) {
        self.block(sender)
    }
}

extension CompletionHandler: Hashable {
    static func == (lhs: CompletionHandler<T>, rhs: CompletionHandler<T>) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
