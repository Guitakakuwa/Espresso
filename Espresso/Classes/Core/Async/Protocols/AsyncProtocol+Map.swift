//
//  AsyncProtocol+Map.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Map */ {
    
    func map<U>(on queue: DispatchQueue = .main, _ body: @escaping ((T) throws -> U)) -> Async<U> {
        
        return Async<U> { resolver in
            
            self.done(on: queue) { value in
                
                do {
                    resolver.fulfill(try body(value))
                }
                catch {
                    resolver.reject(error)
                }
                
            }.catch { error in
                
                resolver.reject(error)
                
            }
            
        }
        
    }
    
    func compactMap<U>(on queue: DispatchQueue = .main, _ body: @escaping ((T) throws -> U?)) -> Async<U> {
        
        return Async<U> { resolver in
            
            self.done(on: queue) { value in
                
                do {
                    if let next = try body(value) {
                        resolver.fulfill(next)
                    }
                    else {
                        resolver.reject(AsyncError.compactMap)
                    }
                }
                catch {
                    resolver.reject(error)
                }
                
            }
            
        }
        
    }
    
}

public extension AsyncProtocol where T: Sequence {

    func mapValues<U>(on queue: DispatchQueue = .main, _ body: @escaping ((T.Iterator.Element) throws -> U)) -> Async<[U]> {
        return map(on: queue, { try $0.map(body) })
    }

    func flatMapValues<U: Sequence>(on queue: DispatchQueue = .main, _ body: @escaping ((T.Iterator.Element) throws -> U)) -> Async<[U.Iterator.Element]> {

        return map(on: queue) { async in
            try async.flatMap { try body($0) }
        }

    }

    func compactMapValues<U>(on queue: DispatchQueue = .main, _ body: @escaping ((T.Iterator.Element) throws -> U?)) -> Async<[U]> {

        return map(on: queue) { async -> [U] in

            #if !swift(>=3.3) || (swift(>=4) && !swift(>=4.1))
                return try async.flatMap(body)
            #else
                return try async.compactMap(body)
            #endif

        }

    }

}
