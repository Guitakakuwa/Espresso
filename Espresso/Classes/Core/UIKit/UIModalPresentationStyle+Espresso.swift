//
//  UIModalPresentationStyle+Espresso.swift
//  Espresso
//
//  Created by Mitch Treece on 10/25/19.
//

import UIKit

public extension UIModalPresentationStyle /* */ {
    
    var isSemiModal: Bool {
        
        if #available(iOS 13, *) {
            
            switch self {
            case .automatic,
                 .pageSheet,
                 .overFullScreen,
                 .overCurrentContext: return true
                
            default: return false
            }
            
        }
        
        switch self {
        case .pageSheet,
             .overFullScreen,
             .overCurrentContext: return true
            
        default: return false
        }
        
    }
    
}
