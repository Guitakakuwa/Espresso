//
//  async.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public func async<U: AsyncProtocol>(_ body: @escaping (() throws -> U)) -> Async<U.T> {
    
    return Async<U.T> { resolver in
        
        do {
            (try body()).done { value in
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
