//
//  CompletionHandler.swift
//  Upful
//
//  Created by Yanik Simpson on 8/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

struct Handler<T>: Hashable {
    let id = UUID().uuidString
    var block: ((T?) -> Void)
    
    init(block: @escaping ((T?) -> Void)) {
        self.block = block
    }
    
    static func == (lhs: Handler<T>, rhs: Handler<T>) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CompletionHandler<T> {

    private var handlers = Set<Handler<T>>()
    
    init(_ block: @escaping ((T?) -> Void) = { _ in }) {
        self.handlers = [Handler(block: block)]
    }
    
    mutating func subscribe(_ block: @escaping ((T?) -> Void)) {
        self.handlers.insert(Handler(block: block))
    }
    
    mutating func addHandler(_ handler: Handler<T>) {
        self.handlers.remove(handler)
        self.handlers.insert(handler)
    }
    
    mutating func unsubscribe(handler: Handler<T>) {
        self.handlers.remove(handler)
    }
    
    func notify(_ sender: T? = nil) {
        handlers.forEach{ $0.block(sender) }
    }
}
