//
//  AsyncProtocol+Done.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Done */ {
    
    @discardableResult
    func done(on queue: DispatchQueue = .main, _ body: @escaping ((T) throws -> ())) -> Async<Void> {
        
        return Async<Void> { resolver in
            
            self.await(on: queue) { result in
                
                switch result {
                case .success(let value):
                    
                    do {
                        try body(value)
                        resolver.fulfill(())
                    }
                    catch {
                        resolver.reject(error)
                    }
                    
                case .failure(let error): resolver.reject(error)
                }
                
            }
            
        }
        
    }
    
}
