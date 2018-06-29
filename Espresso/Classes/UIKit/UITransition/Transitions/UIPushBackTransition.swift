//
//  UIPushBackTransition.swift
//  Espresso
//
//  Created by Mitch Treece on 6/26/18.
//

import UIKit

public class UIPushBackTransition: UITransition {
    
    public var pushBackScale: CGFloat = 0.8
    public var pushBackAlpha: CGFloat = 0.3
    public var roundedCornerRadius: CGFloat = 20
    
    public override init() {
        
        super.init()
        self.presentation.direction = .up
        self.dismissal.direction = .down
        
    }
    
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
        
        let previousClipsToBound = sourceVC.view.clipsToBounds
        let previousCornerRadius = sourceVC.view.layer.cornerRadius
        
        return UITransitionController(setup: {
            
            destinationVC.view.frame = context.finalFrame(for: destinationVC)
            container.addSubview(destinationVC.view)
            destinationVC.view.transform = self.boundsTransform(in: container, direction: settings.direction.reversed())
            
            sourceVC.view.clipsToBounds = true
            
        }, animations: [
            
            UISpringAnimation {
                sourceVC.view.layer.cornerRadius = self.roundedCornerRadius
                sourceVC.view.transform = CGAffineTransform(scaleX: self.pushBackScale, y: self.pushBackScale)
                sourceVC.view.alpha = self.pushBackAlpha
                destinationVC.view.transform = .identity
            }
            
        ], completion: {
            
            sourceVC.view.clipsToBounds = previousClipsToBound
            sourceVC.view.layer.cornerRadius = previousCornerRadius
            sourceVC.view.transform = .identity
            sourceVC.view.alpha = 1
            
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
    private func _dismiss(with info: Info, settings: Settings) -> UITransitionController {
        
        let sourceVC = info.sourceViewController
        let destinationVC = info.destinationViewController
        let container = info.transitionContainerView
        let context = info.context
        
        let previousClipsToBound = destinationVC.view.clipsToBounds
        let previousCornerRadius = destinationVC.view.layer.cornerRadius
        
        return UITransitionController(setup: {
            
            destinationVC.view.alpha = self.pushBackAlpha
            destinationVC.view.frame = context.finalFrame(for: destinationVC)
            container.insertSubview(destinationVC.view, belowSubview: sourceVC.view)
            destinationVC.view.transform = CGAffineTransform(scaleX: self.pushBackScale, y: self.pushBackScale)
            
            destinationVC.view.layer.cornerRadius = self.roundedCornerRadius
            destinationVC.view.clipsToBounds = true
            
        }, animations: [
            
            UISpringAnimation {
                sourceVC.view.transform = self.boundsTransform(in: container, direction: settings.direction)
                destinationVC.view.layer.cornerRadius = previousCornerRadius
                destinationVC.view.transform = .identity
                destinationVC.view.alpha = 1
            }
            
        ], completion: {
                
            destinationVC.view.clipsToBounds = previousClipsToBound
            context.completeTransition(!context.transitionWasCancelled)
                
        })
        
    }
    
}
