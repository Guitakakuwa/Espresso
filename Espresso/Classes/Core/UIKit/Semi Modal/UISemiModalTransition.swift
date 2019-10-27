//
//  UISemiModalTransition.swift
//  Espresso
//
//  Created by Mitch Treece on 10/26/19.
//

import UIKit

internal class UISemiModalTransition: UIPresentationTransition {
    
    override init() {
        
        super.init()
        
        self.interactionController = UITransitionModalInteractionController()
        self.presentation.direction = .up
        self.dismissal.direction = .down
        
    }
    
    override func presentationController(forPresented presented: UIViewController,
                                         presenting: UIViewController?,
                                         source: UIViewController) -> UIPresentationController? {
        
        return UISemiModalPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        
    }
    
    override func transitionController(for transitionType: UITransition.TransitionType,
                                       info: UITransition.Info) -> UITransitionController {
        
        let isPresentation = (transitionType == .presentation)
        let settings = self.settings(for: transitionType)
        
        return isPresentation ?
            present(with: info, settings: settings) :
            dismiss(with: info, settings: settings)
        
    }
    
    private func present(with info: Info, settings: Settings) -> UITransitionController {

        // let sourceVC = info.sourceViewController
        let destinationVC = info.destinationViewController
        let container = info.transitionContainerView
        let context = info.context
        
        return UITransitionController(setup: {
            
            destinationVC.view.transform = self.boundsTransform(
                in: container,
                direction: settings.direction.reversed()
            )

            container.addSubview(destinationVC.view)
            
        }, animations: {
            
            UIAnimation(.spring(damping: 0.9, velocity: CGVector(dx: 0.25, dy: 0)), {
                destinationVC.view.transform = .identity
            })
            
        }, completion: {
            
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
    private func dismiss(with info: Info, settings: Settings) -> UITransitionController {

        let sourceVC = info.sourceViewController
        //let destinationVC = info.destinationViewController
        let container = info.transitionContainerView
        let context = info.context
        
        return UITransitionController(setup: {
            
            // container.addSubview(destinationVC.view)
            
        }, animations: {
            
            UIAnimation {
                
                sourceVC.view.transform = self.boundsTransform(
                    in: container,
                    direction: settings.direction
                )
                
            }
            
        }, completion: {
            
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
}
