//
//  UISemiModalPresentationController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/27/19.
//

import UIKit
import SnapKit

internal class UISemiModalPresentationController: UIPresentationController {
    
    private var presentingSemiModal: UISemiModalViewControllerTransitioning? {
        return (self.presentingViewController as? UISemiModalViewControllerTransitioning)
    }
    
    private var presentedSemiModal: UISemiModalViewControllerTransitioning {
        return (self.presentedViewController as! UISemiModalViewControllerTransitioning)
    }
    
    private lazy var configuration: UISemiModalConfiguration = {
        return self.presentedSemiModal.configuration()
    }()
        
    var statusBarStyle: UIStatusBarStyle {
        return self.transitionHelper?.statusBarStyle ?? .default
    }
    
    private var dimmingView: UIView?
    private var transitionHelper: UISemiModalViewTransitionHelper?
    
    var isTransitioning: Bool = true

    override var frameOfPresentedViewInContainerView: CGRect {
        return self.transitionHelper?.frameForPresentedViewInContainer ?? .zero
    }
    
    private var cornerRadiusOfPresentedView: CGFloat {
        return self.transitionHelper?.cornerRadiusForPresentedView ?? 0
    }
    
//    override init(presentedViewController: UIViewController,
//                  presenting presentingViewController: UIViewController?) {
//
//        super.init(
//            presentedViewController: presentedViewController,
//            presenting: presentingViewController
//        )
//
//    }
    
    func updateForSemiModalStateChanged() {
    
        self.containerView?.setNeedsLayout()
        self.containerView?.layoutIfNeeded()
        
    }
    
    override func containerViewWillLayoutSubviews() {
        
        self.transitionHelper = UISemiModalViewTransitionHelper(
            presenter: self.presentingViewController,
            presented: self.presentedSemiModal,
            container: self.containerView!
        )

        self.presentedViewController.view.layoutIfNeeded()
        
        self.isTransitioning = true

        let timing = UIAnimation.TimingCurve.spring(damping: 1, velocity: CGVector(dx: 0.7, dy: 0.7))

        UIAnimation(timing, duration: 0.4, delay: 0) {

            let dimmingAlpha = self.transitionHelper?.dimmingAlpha ?? 0
            self.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(dimmingAlpha)

            self.transitionHelper!.transformPresentingView()
            
            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.presentedViewController.view.layer.cornerRadius = self.cornerRadiusOfPresentedView

        }.run(completion: {

            self.isTransitioning = false

        })
        
    }
    
    override func presentationTransitionWillBegin() {
        
        self.transitionHelper = UISemiModalViewTransitionHelper(
            presenter: self.presentingViewController,
            presented: self.presentedSemiModal,
            container: self.containerView!
        )
        
        self.transitionHelper!.set(presentation: true)
        
        self.containerView!.addTapGesture { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true, completion: nil)
        }
                
        self.dimmingView = UIView()
        self.dimmingView!.backgroundColor = UIColor.black.withAlphaComponent(self.transitionHelper!.dimmingAlpha)
        self.dimmingView!.alpha = 0
        self.containerView!.addSubview(self.dimmingView!)
        self.dimmingView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.presentedViewController.view.layer.cornerRadius = self.transitionHelper!.cornerRadiusForPresentedView
        
        UIAnimation(.simple(.easeOut), duration: self.configuration.presentationDuration, delay: 0) {
            self.dimmingView!.alpha = 1
        }.run()
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        self.isTransitioning = false
    }

    override func dismissalTransitionWillBegin() {
        
        self.transitionHelper?.set(presentation: false)
        self.isTransitioning = true
        
        UIAnimation(.simple(.easeOut), duration: self.configuration.dismissalDuration, delay: 0) {
            
            self.dimmingView?.alpha = 0

            self.transitionHelper?.transformPresentingView()
            
            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.presentedViewController.view.layer.cornerRadius = self.transitionHelper?.cornerRadiusForPresentedView ?? 0
            
        }.run()
        
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        
        self.presentedViewController.view.layer.cornerRadius = 0
        
        self.dimmingView?.removeFromSuperview()
        self.dimmingView = nil
        
        self.isTransitioning = false
        
    }
        
}
