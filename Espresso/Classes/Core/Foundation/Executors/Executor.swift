//
//  Executor.swift
//  Espresso
//
//  Created by Mitch Treece on 9/24/19.
//

import Foundation

/// Protocol describing the base attributes of an object that executes a closure.
public protocol Executor {
    
    /// Executes a given closure either immediately, or sometime in the future.
    /// - parameter closure: The closure to execute.
    func execute(_ closure: @escaping ()->())
    
}
