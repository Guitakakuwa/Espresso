//
//  Cauterizer.swift
//  Espresso
//
//  Created by Mitch Treece on 9/25/19.
//

import Foundation

public class Cauterizer {
    
    private let async = Async<Void>() // Should be a guarantee

    internal func cauterize() {
        self.async.resolver.fulfill(())
    }

    public func finally(on queue: DispatchQueue = .main, _ body: @escaping ()->()) {

        self.async.done(on: queue) { _ in
            body()
        }

    }
    
}
