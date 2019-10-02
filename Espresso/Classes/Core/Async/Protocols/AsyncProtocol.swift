//
//  AsyncProtocol.swift
//  Espresso
//
//  Created by Mitch Treece on 9/26/19.
//

import Foundation

public protocol AsyncProtocol: Awaitable, Catchable {
    
    associatedtype T
    
}
