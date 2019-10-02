//
//  AsyncProtocol+Sort.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public extension AsyncProtocol where T: Sequence, T.Iterator.Element: Comparable {

    func sortedValues(on queue: DispatchQueue = .main) -> Async<[T.Iterator.Element]> {
        return map(on: queue) { $0.sorted() }
    }

}
