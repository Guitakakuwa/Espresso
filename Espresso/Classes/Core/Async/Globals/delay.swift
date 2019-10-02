//
//  delay.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public func delay(_ time: TimeInterval) -> Async<Void> {

    return Async<Void> { resolver in

        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            resolver.fulfill(())
        }

    }

}
