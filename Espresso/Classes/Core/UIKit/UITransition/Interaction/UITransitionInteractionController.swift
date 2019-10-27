//
//  UITransitionInteractionController.swift
//  Espresso
//
//  Created by Mitch Treece on 6/26/18.
//

import UIKit

open class UITransitionInteractionController: UIPercentDrivenInteractiveTransition {
    
    private(set) public var sourceViewController: UIViewController?
    private(set) public var destinationViewController: UIViewController!
    
    private(set) public var transitionType: UITransition.TransitionType = .presentation {
        didSet {
            transitionTypeDidChange()
        }
    }
    
    public var isTransitioning: Bool = false
    
    internal func _setup(sourceViewController: UIViewController?,
                         destinationViewController: UIViewController) {
        
        self.sourceViewController = sourceViewController
        self.destinationViewController = destinationViewController
        setup()
        
    }
    
    internal func _update(transitionType: UITransition.TransitionType) {
        self.transitionType = transitionType
    }
    
    open func setup() {
        // Override me
    }
    
    open func transitionTypeDidChange() {
        // Override me
    }
    
}
