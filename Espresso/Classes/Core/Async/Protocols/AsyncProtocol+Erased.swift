//
//  AsyncProtocol+Erased.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public extension AsyncProtocol /* Erased */ {
    
    func erased() -> AnyAsync<T> {
        return AnyAsync(self as! Async<T>)
    }
    
}
