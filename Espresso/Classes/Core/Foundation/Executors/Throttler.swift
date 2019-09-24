//
//  Throttler.swift
//  Espresso
//
//  Created by Mitch Treece on 9/23/19.
//

import Foundation

/// `Throttler` ensures that a closure is executed once **within** a given time-interval.
/// Subsequent attempts to execute a closure _before_ the time-interval has passed are ignored.
public class Throttler: Executor {
    
    private var time: TimeInterval
    private var queue: DispatchQueue
    private var workItem: DispatchWorkItem?
    
    /// Initializes a throttler with a specifed time-interval & queue.
    /// - parameter time: The throttle time-interval.
    /// - parameter queue: The `DispatchQueue` to execute closures on; _defaults to main_.
    public init(time: TimeInterval, queue: DispatchQueue = .main) {
        
        self.time = time
        self.queue = queue
        
    }
    
    public func execute(_ closure: @escaping ()->()) {
        
        guard self.workItem == nil else { return }
                
        self.workItem = DispatchWorkItem() { [weak self] in
            
            self?.workItem = nil
            closure()
            
        }
        
        self.queue.async(execute: self.workItem!)
        self.queue.asyncAfter(deadline: .now() + self.time) {
            self.workItem = nil
        }
        
    }
    
}
