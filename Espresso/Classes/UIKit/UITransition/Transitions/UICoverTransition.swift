//
//  UICoverTransition.swift
//  Espresso
//
//  Created by Mitch Treece on 6/26/18.
//

import UIKit

public class UICoverTransition: UITransition {
    
    public var coverAlpha: CGFloat = 0.7
    
    override public func transitionController(for transitionType: TransitionType, info: Info) -> UITransitionController {
        
        let isPresentation = (transitionType == .presentation)
        let settings = self.settings(for: transitionType)
        return isPresentation ? _present(with: info, settings: settings) : _dismiss(with: info, settings: settings)
        
    }
    
    private func _present(with info: Info, settings: Settings) -> UITransitionController {
        
        let sourceVC = info.sourceViewController
        let destinationVC = info.destinationViewController
        let container = info.transitionContainerView
        let context = info.context
        
        return UITransitionController(setup: {
            
            destinationVC.view.frame = context.finalFrame(for: destinationVC)
            destinationVC.view.transform = self.boundsTransform(in: container, direction: settings.direction.reversed())
            container.addSubview(destinationVC.view)
            
        }, animations: {
            
            UIAnimation(.spring(damping: 0.9), {
                sourceVC.view.alpha = self.coverAlpha
                destinationVC.view.transform = .identity
            })
            
        }, completion: {
            
            sourceVC.view.alpha = 1
            sourceVC.view.transform = .identity
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
    private func _dismiss(with info: Info, settings: Settings) -> UITransitionController {
        
        let sourceVC = info.sourceViewController
        let destinationVC = info.destinationViewController
        let container = info.transitionContainerView
        let context = info.context
        
        return UITransitionController(setup: {
            
            destinationVC.view.frame = context.finalFrame(for: destinationVC)
            destinationVC.view.alpha = self.coverAlpha
            container.insertSubview(destinationVC.view, belowSubview: sourceVC.view)
            
        }, animations: {
            
            UIAnimation(.spring(damping: 0.9), {
                sourceVC.view.transform = self.boundsTransform(in: container, direction: settings.direction)
                destinationVC.view.alpha = 1
            })
            
        }, completion: {
                
            sourceVC.view.alpha = 1
            sourceVC.view.transform = .identity
            context.completeTransition(!context.transitionWasCancelled)
                
        })
        
    }
    
}
