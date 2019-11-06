//
//  UISemiModalViewController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/25/19.
//

import UIKit

open class UISemiModalViewController: UIBaseViewController, UISemiModalViewControllerTransitioning {
    
    // Configuration --------------------------------------------------------------
    
    public var style: UISemiModalStyle = .default
    public var preferredSemiModalStatusBarStyle: UIStatusBarStyle = .default
    public var preferredModalStatusBarStyle: UIStatusBarStyle = .default // Only valid when style == cover
    public var preferredFullscreenStatusBarStyle: UIStatusBarStyle = .default
    
    public var presentationDuration: TimeInterval = 0.3 {
        didSet {
            self.semiModalTransition?.presentationDuration = presentationDuration
        }
    }
    
    public var dismissalDuration: TimeInterval = 0.3 {
        didSet {
            self.semiModalTransition?.dismissalDuration = dismissalDuration
        }
    }
    
    public var isSwipeToDismissEnabled: Bool = true {
        didSet {
            self.semiModalTransition?.isSwipeToDismissEnabled = isSwipeToDismissEnabled
        }
    }
    
    // ----------------------------------------------------------------------------
        
    public internal(set) var state: UISemiModalState = .semiModal
    
    public var scrollViewForSemiModalTransition: UIScrollView?
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.semiModalPresentationController?.statusBarStyle ?? .default
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setup()

    }
    
    private func setup() {
        
        self.transition = UISemiModalTransition()
        self.modalPresentationCapturesStatusBarAppearance = true
        
    }
    
    public func transition(to state: UISemiModalState) {
        
        guard self.state != state else { return }
        guard let pc = self.semiModalPresentationController, !pc.isTransitioning else { return }
        
        self.state = state
        self.semiModalPresentationController?.updateForSemiModalStateChanged()
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    open func willTransition(to state: UISemiModalState) {
        // Override
    }
    
    open func didTransition(to state: UISemiModalState) {
        // Override
    }
        
    // MARK: Private
    
    internal func configuration() -> UISemiModalConfiguration {

        return UISemiModalConfiguration(
            style: self.style,
            statusBarStyle: UISemiModalConfiguration.StatusBarStyle(
                semiModal: self.preferredSemiModalStatusBarStyle,
                modal: self.preferredModalStatusBarStyle,
                fullscreen: self.preferredFullscreenStatusBarStyle
            ),
            presentationDuration: self.presentationDuration,
            dismissalDuration: self.dismissalDuration,
            isSwipeToDismissEnabled: self.isSwipeToDismissEnabled
        )
        
    }
    
}
