//
//  all.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public func all<T>(_ asyncs: [Async<T>]) -> Async<[T]> {
    
    return Async<[T]> { resolver in
        
        guard !asyncs.isEmpty else {
            resolver.fulfill([])
            return
        }
        
        asyncs.forEach { async in
            
            async.done { value in
                
                if !asyncs.contains(where: { $0.isPending || $0.isRejected }) {
                    resolver.fulfill(asyncs.compactMap { $0.value })
                }
                
            }.catch { error in
                
                resolver.reject(error)
                
            }
            
        }
        
    }
    
}
