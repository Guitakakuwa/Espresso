//
//  AsyncProtocol+Then.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public extension AsyncProtocol /* Then */ {
    
    func then<U: AsyncProtocol>(on queue: DispatchQueue = .main, _ body: @escaping ((T) throws -> U)) -> Async<U.T> {
        
        return Async<U.T> { resolver in
            
            self.await(on: queue) { result in
                
                switch result {
                case .success(let value):

                    do {

                        let next = try body(value)
                        let nextAsync = next as! Async<U.T>
                        
                        nextAsync.await(on: queue) { nextResult in
                            
                            switch nextResult {
                            case .success(let nextValue): resolver.fulfill(nextValue)
                            case .failure(let nextError): resolver.reject(nextError)
                            }
                            
                        }

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
