//
//  UIViewControllerSemiModalAppearance.swift
//  Espresso
//
//  Created by Mitch Treece on 10/25/19.
//

import UIKit

/// Protocol describing `UIViewController` semi-modal appearance functions.
///
/// A view controller is considered semi-modal if it's modal presentation stye is
/// `automatic`, `pageSheet`, `overFullscreen`, or `overCurrentContext`.
public protocol UIViewControllerSemiModalAppearance: UIViewController {
    
    /// Called when a presented semi-modal view controller is about to be dismissed.
    /// - Parameter animated: Flag indicating if the disappearance will be done with an animation.
    ///
    /// A view controller is considered semi-modal if it's modal presentation stye is
    /// `automatic`, `pageSheet`, `overFullscreen`, or `overCurrentContext`.
    func viewWillAppearFromSemiModalDisappearance(animated: Bool)
    
    /// Called when a presented semi-modal view controller did dismiss.
    /// - Parameter animated: Flag indicating if the disappearance was done with an animation.
    ///
    /// A view controller is considered semi-modal if it's modal presentation stye is
    /// `automatic`, `pageSheet`, `overFullscreen`, or `overCurrentContext`.
    func viewDidAppearFromSemiModalDisappearance(animated: Bool)
    
    /// Called when the view controller's parent `UIPresentationController` attempts to dismiss.
    func viewControllerDidAttemptToDismiss()
    
}
