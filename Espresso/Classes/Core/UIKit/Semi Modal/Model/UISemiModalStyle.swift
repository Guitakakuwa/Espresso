//
//  UISemiModalStyle.swift
//  Espresso
//
//  Created by Mitch Treece on 10/28/19.
//

import Foundation

public enum UISemiModalStyle {
    
    internal enum RawStyle {
        
        case card
        case cover
        
    }
    
    case `default`
    case card
    case cover
    
    internal var rawStyle: RawStyle {
        
        switch self {
        case .default:
            
            if #available(iOS 13, *) {
                return .card
            }
            
            return .cover
            
        case .card: return .card
        case .cover: return .cover
        }
        
    }
    
}
