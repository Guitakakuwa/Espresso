//
//  AsyncProtocol+Do.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Do */ {

    // gives input to closure and returns a an async over the same type.
    // i.e. "passthrough"

    func `do`(on queue: DispatchQueue = .main, _ body: @escaping (T) throws -> ()) -> Async<T> {

        return Async<T> { resolver in
            
            self.done(on: queue) { value in
                
                do {
                    try body(value)
                    resolver.fulfill(value)
                }
                catch {
                    resolver.reject(error)
                }
                
            }.catch { error in
                
                resolver.reject(error)
                
            }

        }

    }

}
