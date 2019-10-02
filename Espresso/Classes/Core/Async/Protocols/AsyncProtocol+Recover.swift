//
//  AnyAsync+Recover.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Recover */ {

    func recover<E: Error>(on queue: DispatchQueue = .main, type: E.Type, _ body: @escaping ((E) throws -> Async<T>)) -> Async<T> {

        return Async<T> { resolver in
            
            self.done { value in
                
                resolver.fulfill(value)
                
            }.catch(on: queue) { error in
                
                guard let e = error as? E else {
                    resolver.reject(error)
                    return
                }
                
                do {
                    
                    try body(e).done { value in
                        resolver.fulfill(value)
                    }.catch { error in
                        resolver.reject(error)
                    }
                    
                }
                catch {
                    resolver.reject(error)
                }
                
            }

        }

    }

    func recover(on queue: DispatchQueue = .main, _ body: @escaping ((Error) throws -> Async<T>)) -> Async<T> {
        return recover(on: queue, type: Error.self, body)
    }

}
