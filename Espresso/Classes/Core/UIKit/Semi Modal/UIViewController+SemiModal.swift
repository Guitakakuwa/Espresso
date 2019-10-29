//
//  UIViewController+SemiModal.swift
//  Espresso
//
//  Created by Mitch Treece on 10/27/19.
//

import UIKit

public extension UIViewController /* Semi Modal */ {
    
    var isPresentedSemiModally: Bool {
        
        return self.transitioningDelegate is UISemiModalTransition
            && self.modalPresentationStyle == .custom
            && self.presentingViewController != nil
        
    }
    
}
