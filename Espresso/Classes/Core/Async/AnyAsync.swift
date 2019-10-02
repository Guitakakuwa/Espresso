//
//  AnyAsync.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public class AnyAsync<T>: AsyncProtocol {
    
    private let _async: Async<T>
    
    public init(_ async: Async<T>) {
        self._async = async
    }
    
    public func await(on queue: DispatchQueue, _ resolution: @escaping (Result<T, Error>) -> ()) {
        self._async.await(on: queue, resolution)
    }
    
}
