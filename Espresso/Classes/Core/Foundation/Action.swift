//
//  Action.swift
//  Espresso
//
//  Created by Mitch Treece on 3/10/19.
//

import Foundation

/**
 Protocol describing the base attributes of an action.
 */
public protocol Action {
    
    associatedtype T
    
    /**
     Runs the action with a given data object.
     - Parameter data: The data object.
     */
    func run(with data: T?)
    
}

/**
 An action that is executed with given data.
 */
public class DataAction<T>: Action {
    
    private let block: (T?)->()
    private var throttler: Throttler?
    
    /**
     Initializes an action using a given execution block.
     - Parameter block: The action's execution block.
     */
    public init(_ block: @escaping (T?)->()) {
        self.block = block
    }
    
    /// Initializes a throttled action using a given execution block.
    /// - parameter throttled: The throttle time.
    /// - parameter queue: The `DispatchQueue` to execute the block on.
    /// - parameter block: The action's execution block.
    public init(throttled: TimeInterval, queue: DispatchQueue = .main, _ block: @escaping (T?)->()) {
        
        self.block = block
        
        self.throttler = Throttler(
            time: throttled,
            queue: queue
        )
        
    }
    
    public func run(with data: T?) {
        
        if let throttler = self.throttler {
            throttler.run { [weak self] in
                self?.block(data)
            }
        }
        else {
            self.block(data)
        }
        
    }
    
}

/**
 An action that is executed without any data.
 */
public class VoidAction: Action {
    
    public typealias T = Void
    
    private let block: ()->()
    private var throttler: Throttler?
    
    /**
     Initializes an action using a given execution block.
     - Parameter block: The action's execution block.
     */
    public init(_ block: @escaping ()->()) {
        self.block = block
    }
    
    /// Initializes a throttled action using a given execution block.
    /// - parameter throttled: The throttle time.
    /// - parameter queue: The `DispatchQueue` to execute the block on.
    /// - parameter block: The action's execution block.
    public init(throttled: TimeInterval, queue: DispatchQueue = .main, _ block: @escaping ()->()) {
        
        self.block = block
        
        self.throttler = Throttler(
            time: throttled,
            queue: queue
        )
        
    }
    
    public func run(with data: T? = nil) {
    
        if let throttler = self.throttler {
            throttler.run { [weak self] in
                self?.block()
            }
        }
        else {
            self.block()
        }
        
    }
    
}
