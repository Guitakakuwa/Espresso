//
//  EventObserver.swift
//  Espresso
//
//  Created by Mitch Treece on 9/20/19.
//

import Foundation

internal class EventObserver<Value> {
            
    private var handler: (Value)->()
    
    init(handler: @escaping (Value)->()) {
        self.handler = handler
    }
    
    func send(value: Value) {
        self.handler(value)
    }
    
}
