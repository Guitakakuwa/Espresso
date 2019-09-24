//
//  Debouncer.swift
//  Espresso
//
//  Created by Mitch Treece on 9/23/19.
//

import Foundation


/// `Debouncer` ensures that a closure is executed once **after** a given time-interval.
/// Subsequent attempts to execute a closure _before_ the time-interval has passed will reset
/// the elapsed time & replace the closure.
///
/// Only the last closure provided will be executed **after** the debounce time-interval has passed.
public class Debouncer: Executor {
    
    private var time: TimeInterval
    private var queue: DispatchQueue
    
    private var workItem: DispatchWorkItem?
    private var lastFireDate: Date?
    
    /// Initializes a debouncer with a specifed time-interval & queue.
    /// - parameter time: The debounce time-interval.
    /// - parameter queue: The `DispatchQueue` to execute closures on; _defaults to main_.
    public init(time: TimeInterval, queue: DispatchQueue = .main) {
        
        self.time = time
        self.queue = queue
        
    }
    
    public func execute(_ closure: @escaping ()->()) {
        
        // Cancel the existing work item if it exists & hasn't executed yet.
        
        self.workItem?.cancel()

        // Re-init our work item; resetting our last fire date when called.
        
        self.workItem = DispatchWorkItem() { [weak self] in
            
            self?.lastFireDate = Date()
            closure()
            
        }
        
        guard let date = self.lastFireDate else {
            
            // If we have no last fire date, this is the first time we're being asked to run.
            // Schedule our work with our time-interval.
            
            self.queue.asyncAfter(
                deadline: .now() + self.time,
                execute: self.workItem!
            )
            
            return
            
        }
        
        // If the delta between our previous fire date & now is > our time-interval,
        // run our work immediately. Otherwise, schedule our work with out time-interval.
        
        let delay = (date.timeIntervalSinceNow > self.time) ? 0 : self.time
        
        queue.asyncAfter(
            deadline: .now() + delay,
            execute: self.workItem!
        )
        
    }
    
}
