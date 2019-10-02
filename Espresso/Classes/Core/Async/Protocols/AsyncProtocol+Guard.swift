//
//  AsyncProtocol+Guard.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Guard */ {

    func `guard`(on queue: DispatchQueue = .main, _ body: @escaping (T)->Bool) -> Async<T> {

        return Async<T> { resolver in
            
            self.done(on: queue) { value in
                
                guard body(value) else {
                    resolver.reject(AsyncError.guard)
                    return
                }

                resolver.fulfill(value)
                
            }.catch { error in
                
                resolver.reject(error)
                
            }

        }

    }

}
