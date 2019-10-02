//
//  timeout.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public func timeout<T>(_ time: TimeInterval) -> Async<T> {

    return Async<T> { resolver in

        delay(time).done { _ in
            resolver.reject(AsyncError.timeout)
        }

    }

}
