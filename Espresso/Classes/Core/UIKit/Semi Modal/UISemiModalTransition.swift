//
//  UISemiModalTransition.swift
//  Espresso
//
//  Created by Mitch Treece on 10/26/19.
//

import UIKit

internal class UISemiModalTransition: UIPresentationTransition {
    
    internal var presentationDuration: TimeInterval = 0.4
    internal var dismissalDuration: TimeInterval = 0.3
    internal var isSwipeToDismissEnabled: Bool = true
    
    override init() {
                
        super.init()
        
        // self.interactionController = UITransitionModalInteractionController()
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

        let context = info.context
        let container = info.transitionContainerView
        let destinationVC = info.destinationViewController
        
        let destinationFinalFrame = context.finalFrame(for: destinationVC)
        let destinationInitialFrame = CGRect(
            x: 0,
            y: container.bounds.height,
            width: container.bounds.width,
            height: container.bounds.height
        )
        
        return UITransitionController(setup: {
            
            destinationVC.view.frame = destinationInitialFrame
            container.addSubview(destinationVC.view)
            
        }, animations: {

            UIAnimation(.material(.standard), duration: self.presentationDuration, delay: 0) {
                destinationVC.view.frame = destinationFinalFrame
            }
            
        }, completion: {
            
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
    private func dismiss(with info: Info, settings: Settings) -> UITransitionController {

        let context = info.context
        let container = info.transitionContainerView
        let sourceVC = info.sourceViewController

        let sourceFinalFrame = CGRect(
            x: 0,
            y: container.bounds.height,
            width: container.bounds.width,
            height: container.bounds.height
        )
        
        return UITransitionController(setup: nil, animations: {
            
            UIAnimation(.material(.standard), duration: self.dismissalDuration, delay: 0) {
                sourceVC.view.frame = sourceFinalFrame
            }
            
        }, completion: {
            
            context.completeTransition(!context.transitionWasCancelled)
            
        })
        
    }
    
}
