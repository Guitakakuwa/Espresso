//
//  Awaiter.swift
//  Espresso
//
//  Created by Mitch Treece on 9/25/19.
//

import Foundation

public struct Awaiter<T> {
    
    private var queue: DispatchQueue
    private var body: (Result<T, Error>)->()
    
    public init(on queue: DispatchQueue = .main, _ body: @escaping (Result<T, Error>)->()) {
        
        self.queue = queue
        self.body = body
        
    }
    
    public func deliver(_ result: Result<T, Error>) {
        
        self.queue.async {
            self.body(result)
        }
        
    }
    
}
