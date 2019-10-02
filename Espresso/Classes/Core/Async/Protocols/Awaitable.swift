//
//  Awaitable.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public protocol Awaitable {

    associatedtype T

    func await(on queue: DispatchQueue, _ resolution: @escaping (Result<T, Error>)->())

}

public extension Awaitable {
    
    func await(_ resolution: @escaping (Result<T, Error>)->()) {
        await(on: .main, resolution)
    }
    
}
