//
//  UIBaseNavigationController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/25/19.
//

import UIKit

/// UINavigationController` subclass that provides common helper functions & properties.
open class UIBaseNavigationController: UINavigationController, UIViewControllerSemiModalAppearance {
    
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
    
    open func viewWillAppearFromSemiDisappearance(animated: Bool) {
        // Override
    }
    
    open func viewDidAppearFromSemiDisappearance(animated: Bool) {
        // Override
    }
    
    open func viewDidAttemptToDismiss() {
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
            presenter.viewWillAppearFromSemiDisappearance(animated: flag)
        }
        
        super.dismiss(
            animated: flag,
            completion: {
                                
                if presenterDidSemiDisappear {
                    presenter.viewDidAppearFromSemiDisappearance(animated: flag)
                }
                
                completion?()
                
            })
        
    }
    
}

extension UIBaseNavigationController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        
        guard let presenting = presentationController.presentingViewController as? UIViewControllerSemiModalAppearance,
            let presented = presentationController.presentedViewController as? UIViewControllerSemiModalAppearance else { return }
        
        if presented.modalPresentationStyle.isSemiModal {
            presenting.viewWillAppearFromSemiDisappearance(animated: true)
        }
        
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        guard let presenting = presentationController.presentingViewController as? UIViewControllerSemiModalAppearance,
            let presented = presentationController.presentedViewController as? UIViewControllerSemiModalAppearance else { return }
        
        if presented.modalPresentationStyle.isSemiModal {
            presenting.viewDidAppearFromSemiDisappearance(animated: true)
        }
        
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        viewDidAttemptToDismiss()
    }
    
}
