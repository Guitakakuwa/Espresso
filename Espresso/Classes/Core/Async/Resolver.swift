//
//  Task.swift
//  Espresso
//
//  Created by Mitch Treece on 9/24/19.
//

import Foundation

public final class Resolver<T> {
    
    private var resolution: ((Result<T, Error>)->())?
    
    internal init(resolution: @escaping (Result<T, Error>)->()) {
        self.resolution = resolution
    }

    public func fulfill(_ value: T) {
        self.resolution?(.success(value))
    }
    
    public func reject(_ error: Error) {
        self.resolution?(.failure(error))
    }
    
}
