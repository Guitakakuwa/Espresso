//
//  AsyncProtocol+Voided.swift
//  Espresso
//
//  Created by Mitch Treece on 9/27/19.
//

import Foundation

public extension AsyncProtocol /* Voided */ {
    
    func voided() -> Async<Void> {
        return map { _ in }
    }
    
}
