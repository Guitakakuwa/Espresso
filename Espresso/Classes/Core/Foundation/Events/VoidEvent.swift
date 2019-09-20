//
//  VoidEvent.swift
//  Espresso
//
//  Created by Mitch Treece on 9/18/19.
//

import Foundation

#if canImport(Combine)
import Combine
#endif

/// An observable event that dispatches with no value.
public class VoidEvent {
    
    private let event = Event<Void>()
    
    /// The event's dispatch publisher.
    @available(iOS 13, *)
    public var publisher: AnyPublisher<Void, Never> {
        return self.event.publisher
    }
    
    /// Initializes an event.
    public init() {
        //
    }
    
    /// Adds an observer using a given handler.
    /// - parameter handler: The handler called when a dispatching.
    /// - returns: An event token.
    @discardableResult
    public func addObserver(_ handler: @escaping ()->()) -> EventToken<Void> {
        return self.event.addObserver(handler)
    }
    
    /// Removes an observer using an event token.
    /// - parameter token: The event token.
    public func removeObserver(token: EventToken<Void>) {
        self.event.removeObserver(token: token)
    }
    
    /// Removes all observers.
    public func removeAllObservers() {
        self.event.removeAllObservers()
    }
    
    /// Dispatches to all observers.
    public func dispatch() {
        self.event.dispatch(value: ())
    }
    
}
