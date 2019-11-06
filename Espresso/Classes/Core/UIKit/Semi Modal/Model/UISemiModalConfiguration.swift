//
//  UISemiModalConfiguration.swift
//  Espresso
//
//  Created by Mitch Treece on 10/30/19.
//

import UIKit

internal struct UISemiModalConfiguration {
    
    struct StatusBarStyle {
        
        var semiModal: UIStatusBarStyle
        var modal: UIStatusBarStyle
        var fullscreen: UIStatusBarStyle
        
    }
    
    var style: UISemiModalStyle
    var statusBarStyle: StatusBarStyle
    
    var presentationDuration: TimeInterval
    var dismissalDuration: TimeInterval
    
    var isSwipeToDismissEnabled: Bool
    
}
