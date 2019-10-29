//
//  UISemiModalAppearanceHelper.swift
//  Espresso
//
//  Created by Mitch Treece on 10/28/19.
//

import UIKit

internal class UISemiModalAppearanceHelper {
    
    private weak var presenter: UIViewController!
    private weak var presented: UISemiModalViewController!
    private weak var container: UIView?
    
    var isPresentation: Bool = true
    
    private var containerSize: CGSize {
        
        return CGSize(
            width: self.container?.bounds.width ?? UIScreen.main.bounds.width,
            height: self.container?.bounds.height ?? UIScreen.main.bounds.height
        )
        
    }
    
    private lazy var configuration: UISemiModalViewController.Configuration = {
        return self.presented.configuration()
    }()
    
    // MARK: Presenting
    
    var statusBarStyle: UIStatusBarStyle {
        
        //        if self.state == .fullscreen {
        //            return self.preferredFullscreenStatusBarStyle
        //        }
        //        else if let fullscreen = self.firstAncestorInSemiModalFullscreenStyle,
        //            let fullscreenDepth = depth(of: fullscreen) {
        //
        //            if let card = self.firstAncestorInSemiModalCardStyle,
        //                let cardDepth = depth(of: card) {
        //
        //                if fullscreenDepth < cardDepth {
        //                    return self.preferredFullscreenStatusBarStyle
        //                }
        //                else {
        //                    return .lightContent
        //                }
        //
        //            }
        //
        //        }
        //
        //        switch self.state {
        //        case .semiModal:
        //            return self.preferredSemiModalStatusBarStyle
        //        case .modal:
        //
        //            if self.style.rawStyle == .card {
        //                return .lightContent
        //            }
        //
        //            return self.preferredModalStatusBarStyle
        //
        //        default: break
        //        }
        
        // return .default
        
        if let _ = self.presenter as? UISemiModalViewControllerTransitioning {
            
            if self.presented.state == .fullscreen {
                return self.configuration.statusBarStyle.fullscreen
            }
                
//            else if let fullscreen = self.presented.firstSemiModalFullscreenAncestor {
//
//            }
            
            return .default
            
        }
        else {
            
            switch presented.state {
            case .semiModal: return self.configuration.statusBarStyle.semiModal
            case .modal:
                
                switch self.presented.style.rawStyle {
                case .card: return .lightContent
                case .cover: return self.configuration.statusBarStyle.modal
                }
                
            case .fullscreen: return self.configuration.statusBarStyle.fullscreen
            }
            
        }
        
    }
    
    var dimmingAlphaOfPresentingView: CGFloat {
        
        switch self.presented.state {
        case .semiModal: return self.presenter.isPresentedSemiModally ? 0 : UISemiModalConstants.dimmingAlpha
        case .modal, .fullscreen: return UISemiModalConstants.dimmingAlpha
        }
        
    }
    
    var transformOfPresentingView: CGAffineTransform {
        
        return UISemiModalPresentingViewTransform.for(
            presenter: self.presenter,
            presented: self.presented,
            inContainer: self.container!,
            transition: self.isPresentation ? .presentation : .dismissal
        )

    }
    
    var cornerRadiusOfPresentingView: CGFloat {
                
        switch self.presented.state {
        case .semiModal: return self.presenter.isPresentedSemiModally ? UISemiModalConstants.cardCornerRadius : 0
        case .modal, .fullscreen:
            
            switch self.configuration.style.rawStyle {
            case .card: return UISemiModalConstants.cardCornerRadius
            case .cover: return 0
            }
            
        }
        
    }
    
    // MARK: Presented
    
    var frameOfPresentedViewInContainerView: CGRect {
             
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var contentHeight: CGFloat = self.containerSize.height
        
        switch self.presented.state {
        case .semiModal: contentHeight = (self.containerSize.height / 2)
        case .modal:
            
            switch self.configuration.style.rawStyle {
            case .card: contentHeight -= (statusBarHeight + UISemiModalConstants.cardStackOffset)
            case .cover: contentHeight -= statusBarHeight
            }
            
        case .fullscreen: break
        }
        
        let yOffset = (self.containerSize.height - contentHeight)
        
        return CGRect(
            x: 0,
            y: yOffset,
            width: self.containerSize.width,
            height: contentHeight
        )
        
    }
    
    var cornerRadiusOfPresentedView: CGFloat {
        
        switch self.presented.state {
        case .semiModal, .modal: return UISemiModalConstants.cardCornerRadius
        case .fullscreen: return 0
        }
        
    }
    
    func set(presenter: UIViewController,
             presented: UISemiModalViewController,
             containerView: UIView?) {
        
        self.presenter = presenter
        self.presented = presented
        self.container = containerView
        
    }
    
}
