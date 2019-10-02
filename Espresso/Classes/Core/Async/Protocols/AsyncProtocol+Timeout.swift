//
//  AsyncProtocol+Timeout.swift
//  Espresso
//
//  Created by Mitch Treece on 9/25/19.
//

import Foundation

public extension AsyncProtocol /* Timeout */ {
    
    func timeout(_ time: TimeInterval) -> Async<T> {
        
        return race([
            self as! Async<T>,
            Espresso.timeout(time)
        ])
        
    }
    
}
