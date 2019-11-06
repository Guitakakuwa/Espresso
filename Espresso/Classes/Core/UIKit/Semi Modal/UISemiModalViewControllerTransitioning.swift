//
//  UISemiModalViewControllerTransitioning.swift
//  Espresso
//
//  Created by Mitch Treece on 10/28/19.
//

import UIKit

internal protocol UISemiModalViewControllerTransitioning: UIViewController {
    
    var state: UISemiModalState { get }
    var style: UISemiModalStyle { get set }
    var transition: UITransition? { get }
    var presentationController: UIPresentationController? { get }
    var scrollViewForSemiModalTransition: UIScrollView? { get }
    
    func configuration() -> UISemiModalConfiguration
    
}

internal extension UISemiModalViewControllerTransitioning {
    
    var semiModalTransition: UISemiModalTransition? {
        return self.transition as? UISemiModalTransition
    }
    
    var semiModalPresentationController: UISemiModalPresentationController? {
        return self.presentationController as? UISemiModalPresentationController
    }
    
    var isInSemiModalFullscreenStyle: Bool {
        return (self.state == .fullscreen)
    }
    
    var firstSemiModalFullscreenAncestor: UISemiModalViewControllerTransitioning? {
        
        guard let parent = self.presentingViewController as? UISemiModalViewControllerTransitioning else {
            return nil
        }
        
        return _firstSemiModalFullscreenAncestor(parent)
        
    }
    
    var isInSemiModalCardStyle: Bool {
        return (self.state == .modal) && (self.style.rawStyle == .card)
    }
    
    var firstSemiModalCardAncestor: UISemiModalViewControllerTransitioning? {
        
        guard let parent = self.presentingViewController as? UISemiModalViewControllerTransitioning else {
            return nil
        }
        
        return _firstSemiModalCardAncestor(parent)
        
    }
    
    func depth(of ancestor: UISemiModalViewControllerTransitioning, currentDepth: Int = 0) -> Int? {
        
        guard self != ancestor else { return currentDepth }
        
        if let parent = self.presentingViewController as? UISemiModalViewControllerTransitioning {
            
            let parentDepth = (currentDepth + 1)
            
            if parent == ancestor {
                return parentDepth
            }
            
            return parent.depth(
                of: ancestor,
                currentDepth: parentDepth
            )
            
        }
        
        return nil
        
    }
        
    private func _firstSemiModalFullscreenAncestor(_ ancestor: UISemiModalViewControllerTransitioning) -> UISemiModalViewControllerTransitioning? {
        
        if ancestor.isInSemiModalFullscreenStyle {
            return ancestor
        }
        
        guard let greatAncestor = ancestor.presentationController?.presentingViewController as? UISemiModalViewControllerTransitioning else {
            return nil
        }
        
        return _firstSemiModalFullscreenAncestor(greatAncestor)
        
    }
    
    private func _firstSemiModalCardAncestor(_ ancestor: UISemiModalViewControllerTransitioning) -> UISemiModalViewControllerTransitioning? {
                
        if ancestor.isInSemiModalCardStyle {
            return ancestor
        }
        
        guard let greatAncestor = ancestor.presentationController?.presentingViewController as? UISemiModalViewControllerTransitioning else {
            return nil
        }
        
        return _firstSemiModalCardAncestor(greatAncestor)
        
    }
    
}
