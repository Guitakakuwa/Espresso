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
    
//    override var presentationStyle: UIModalPresentationStyle {
//
//        if #available(iOS 13, *) {
//
//        }
//
//    }
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        return self.containerView?.bounds ?? .zero
//    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        
        self.dimmingView = UIView()
        self.dimmingView!.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        // self.dimmingView!.alpha = 0
        self.containerView!.addSubview(self.dimmingView!)
        self.dimmingView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
//    override func presentationTransitionDidEnd(_ completed: Bool) {
//
//    }
//
//    override func dismissalTransitionWillBegin() {
//
//    }
//
//    override func dismissalTransitionDidEnd(_ completed: Bool) {
//
//    }
//
//    override func containerViewWillLayoutSubviews() {
//
//    }
//
//    override func containerViewDidLayoutSubviews() {
//
//    }
    
}
