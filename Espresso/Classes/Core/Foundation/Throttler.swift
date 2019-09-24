//
//  Throttler.swift
//  Espresso
//
//  Created by Mitch Treece on 9/23/19.
//

import Foundation

public class Throttler {
    
    private var time: TimeInterval
    private var queue: DispatchQueue
    
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var lastFireDate: Date = .distantPast
    
    public init(time: TimeInterval, queue: DispatchQueue = .main) {
        
        self.time = time
        self.queue = queue
        
    }
    
    public func run(_ block: @escaping ()->()) {
        
        self.workItem.cancel()
        self.workItem = DispatchWorkItem() { [weak self] in
            self?.lastFireDate = Date()
            block()
        }
        
        let elapsed = Date().timeIntervalSince(self.lastFireDate)
        let delay = (elapsed > self.time) ? 0 : self.time
        
        self.queue.asyncAfter(
            deadline: .now() + delay,
            execute: self.workItem
        )
        
    }
    
}
