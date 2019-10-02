//
//  race.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public func race<T>(_ asyncs: [Async<T>]) -> Async<T> {

    return Async<T> { resolver in

        guard !asyncs.isEmpty else {
            resolver.reject(AsyncError.emptyRace)
            return
        }

        asyncs.forEach { async in

            async.done { value in
                resolver.fulfill(value)
            }.catch { error in
                resolver.reject(error)
            }

        }

    }

}
