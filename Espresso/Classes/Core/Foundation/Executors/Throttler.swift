//
//  Throttler.swift
//  Espresso
//
//  Created by Mitch Treece on 9/23/19.
//

import Foundation

public class Throttler: Executor {
    
    private var time: TimeInterval
    private var queue: DispatchQueue
    private var workItem: DispatchWorkItem?
    
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
