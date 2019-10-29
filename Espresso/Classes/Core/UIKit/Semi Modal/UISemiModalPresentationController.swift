//
//  UISemiModalPresentationController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/27/19.
//

import UIKit
import SnapKit

internal class UISemiModalPresentationController: UIPresentationController {
    
    private var dimmingView: UIView?
    
    private var presentingSemiModalViewController: UISemiModalViewController? {
        return (self.presentingViewController as? UISemiModalViewController)
    }
    
    private var presentedSemiModalViewController: UISemiModalViewController {
        return (self.presentedViewController as! UISemiModalViewController)
    }
    
    private lazy var configuration: UISemiModalViewController.Configuration = {
        return self.presentedSemiModalViewController.configuration()
    }()
    
    private let appearance = UISemiModalAppearanceHelper()
    
    var statusBarStyle: UIStatusBarStyle {
        return self.appearance.statusBarStyle
    }
    
    var isTransitioning: Bool = true

    override var frameOfPresentedViewInContainerView: CGRect {
        return self.appearance.frameOfPresentedViewInContainerView
    }
    
    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
              
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

    }
    
    func updateForSemiModalStateChanged() {
    
        self.containerView?.setNeedsLayout()
        self.containerView?.layoutIfNeeded()
        
    }
    
    override func containerViewWillLayoutSubviews() {
        
        self.presentedViewController.view.layoutIfNeeded()
        
        self.appearance.set(
            presenter: self.presentingViewController,
            presented: self.presentedSemiModalViewController,
            containerView: self.containerView
        )

        self.isTransitioning = true

        let timing = UIAnimation.TimingCurve.spring(damping: 1, velocity: CGVector(dx: 0.7, dy: 0.7))

        UIAnimation(timing, duration: 0.4, delay: 0) {

            self.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(self.appearance.dimmingAlphaOfPresentingView)

            self.presentingViewController.view.transform = self.appearance.transformOfPresentingView
            self.presentingViewController.view.layer.cornerRadius = self.appearance.cornerRadiusOfPresentingView

            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.presentedViewController.view.layer.cornerRadius = self.appearance.cornerRadiusOfPresentedView

        }.run(completion: {

            self.isTransitioning = false

        })
        
    }
    
    override func presentationTransitionWillBegin() {
        
        self.appearance.set(
            presenter: self.presentingViewController,
            presented: self.presentedSemiModalViewController,
            containerView: self.containerView
        )
        
        self.appearance.isPresentation = true
        
        self.containerView!.addTapGesture { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        self.dimmingView = UIView()
        self.dimmingView!.backgroundColor = UIColor.black.withAlphaComponent(self.appearance.dimmingAlphaOfPresentingView)
        self.dimmingView!.alpha = 0
        self.containerView!.addSubview(self.dimmingView!)
        self.dimmingView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.presentingViewController.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.presentingViewController.view.layer.masksToBounds = true
        
        self.presentedViewController.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.presentedViewController.view.layer.cornerRadius = self.appearance.cornerRadiusOfPresentedView
        self.presentedViewController.view.layer.masksToBounds = true
        
        UIAnimation(.simple(.easeOut), duration: self.configuration.presentationDuration, delay: 0) {
            self.dimmingView!.alpha = 1
        }.run()
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        self.isTransitioning = false
    }

    override func dismissalTransitionWillBegin() {
        
        self.appearance.isPresentation = false
        self.isTransitioning = true
        
        UIAnimation(.simple(.easeOut), duration: self.configuration.dismissalDuration, delay: 0) {
            
            self.dimmingView!.alpha = 0
            
            self.presentingViewController.view.transform = self.appearance.transformOfPresentingView
            self.presentingViewController.view.layer.cornerRadius = self.appearance.cornerRadiusOfPresentingView

            self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
            self.presentedViewController.view.layer.cornerRadius = self.appearance.cornerRadiusOfPresentedView
            
        }.run()
        
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        
        self.presentedViewController.view.layer.cornerRadius = 0
        
        self.dimmingView?.removeFromSuperview()
        self.dimmingView = nil
        
        self.isTransitioning = false
        
    }
        
}
