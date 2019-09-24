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
    private var workItem: DispatchWorkItem?
    
    public init(time: TimeInterval, queue: DispatchQueue = .main) {
        
        self.time = time
        self.queue = queue
        
    }
    
    public func run(_ block: @escaping ()->()) {
        
        guard self.workItem == nil else { return }
                
        self.workItem = DispatchWorkItem() { [weak self] in

            block()
            self?.workItem = nil
            
        }
        
        self.queue.asyncAfter(
            deadline: .now() + self.time,
            execute: self.workItem!
        )
        
    }
    
}
