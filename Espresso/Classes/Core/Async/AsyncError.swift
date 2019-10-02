//
//  AsyncError.swift
//  Espresso
//
//  Created by Mitch Treece on 9/25/19.
//

import Foundation

public enum AsyncError: Error {
    
    public struct Cancelled: Error {
        //
    }
        
    case compactMap
    case `guard`
    case timeout
    case emptyRace
    
}
