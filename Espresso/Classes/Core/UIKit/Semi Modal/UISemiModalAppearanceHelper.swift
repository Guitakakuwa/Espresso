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
    
    private var containerSize: CGSize {
        
        return CGSize(
            width: self.container?.bounds.width ?? UIScreen.main.bounds.width,
            height: self.container?.bounds.height ?? UIScreen.main.bounds.height
        )
        
    }
    
    private let dimmingAlpha: CGFloat = 0.3
    private let cardScale: CGFloat = 0.9
    private let cardStackOffset: CGFloat = 10
    private let cardCornerRadius: CGFloat = 14
    
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
        
        return .default
        
    }
    
    var dimmingAlphaOfPresentingView: CGFloat {
        
        switch self.presented.state {
        case .semiModal: return self.presenter.isPresentedSemiModally ? 0 : self.dimmingAlpha
        case .modal, .fullscreen: return self.dimmingAlpha
        }
        
    }
    
    var transformOfPresentingView: CGAffineTransform {
                
        switch self.presented.state {
        case .semiModal:
                        
            if let presenting = self.presenter as? UISemiModalViewController {
                
                switch self.configuration.style.rawStyle {
                case .card:
                    
                    let presenterHeight = presenting.preferredContentSize.height
                    let scaledPresenterHeight = (presenterHeight * self.cardScale)
                    let yOffset = -(((presenterHeight - scaledPresenterHeight) / 2) + self.cardStackOffset)
                    
                    return CGAffineTransform(
                        scaleX: self.cardScale,
                        y: self.cardScale
                    ).translatedBy(x: 0, y: yOffset)
                    
                case .cover:
                    
                    return CGAffineTransform(
                        scaleX: self.cardScale,
                        y: self.cardScale
                    )
                    
                }
                
            }
            
            return .identity
            
        case .modal, .fullscreen:
            
            switch self.configuration.style.rawStyle {
            case .card:
                
                return CGAffineTransform(
                    scaleX: self.cardScale,
                    y: self.cardScale
                )
                
            case .cover: return .identity
            }
            
        }
        
    }
    
    var cornerRadiusOfPresentingView: CGFloat {
                
        switch self.presented.state {
        case .semiModal: return self.presenter.isPresentedSemiModally ? self.cardCornerRadius : 0
        case .modal, .fullscreen:
            
            switch self.configuration.style.rawStyle {
            case .card: return self.cardCornerRadius
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
            case .card: contentHeight -= (statusBarHeight + self.cardStackOffset)
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
        case .semiModal, .modal: return self.cardCornerRadius
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
