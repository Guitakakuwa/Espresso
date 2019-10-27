//
//  UIBaseViewController.swift
//  Director
//
//  Created by Mitch Treece on 9/16/19.
//

import UIKit

/// UIViewController` subclass that provides common helper functions & properties.
open class UIBaseViewController: UIViewController, UIViewControllerSemiModalAppearance {
    
    @available(iOS 12, *)
    public var userInterfaceStyle: UIUserInterfaceStyle {
        return self.traitCollection.userInterfaceStyle
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 12, *) {
            
            let previousInterfaceStyle = previousTraitCollection?.userInterfaceStyle
            let newInterfaceStyle = self.traitCollection.userInterfaceStyle
            
            if newInterfaceStyle != previousInterfaceStyle {
                userInterfaceStyleDidChange()
            }
            
        }
        
    }
    
    /// Called when the system's `UIUserInterfaceStyle` changes.
    /// Override this function to update your interface as needed.
    @available(iOS 12, *)
    open func userInterfaceStyleDidChange() {
        // Override
    }
    
    open func viewWillAppearFromSemiModalDisappearance(animated: Bool) {
        // Override
    }
    
    open func viewDidAppearFromSemiModalDisappearance(animated: Bool) {
        // Override
    }
    
    open func viewControllerDidAttemptToDismiss() {
        // Override
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        guard let presenter = self.presentingViewController as? UIViewControllerSemiModalAppearance else {
            
            super.dismiss(
                animated: flag,
                completion: completion
            )
            
            return
            
        }
        
        var presenterDidSemiDisappear: Bool = false
        
        if self.modalPresentationStyle.isSemiModal {
            presenterDidSemiDisappear = true
            presenter.viewWillAppearFromSemiModalDisappearance(animated: flag)
        }
        
        super.dismiss(
            animated: flag,
            completion: {
                                
                if presenterDidSemiDisappear {
                    presenter.viewDidAppearFromSemiModalDisappearance(animated: flag)
                }
                
                completion?()
                
            })
        
    }
    
}

extension UIBaseViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        
        guard let presenting = presentationController.presentingViewController as? UIViewControllerSemiModalAppearance,
            let presented = presentationController.presentedViewController as? UIViewControllerSemiModalAppearance else { return }
        
        if presented.modalPresentationStyle.isSemiModal {
            presenting.viewWillAppearFromSemiModalDisappearance(animated: true)
        }
        
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        guard let presenting = presentationController.presentingViewController as? UIViewControllerSemiModalAppearance,
            let presented = presentationController.presentedViewController as? UIViewControllerSemiModalAppearance else { return }
        
        if presented.modalPresentationStyle.isSemiModal {
            presenting.viewDidAppearFromSemiModalDisappearance(animated: true)
        }
        
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        viewControllerDidAttemptToDismiss()
    }
    
}
