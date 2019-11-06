//
//  UISemiModalViewTransitionHelper.swift
//  Espresso
//
//  Created by Mitch Treece on 10/30/19.
//

import UIKit

internal class UISemiModalViewTransitionHelper {

    private weak var presenter: UIViewController!
    private weak var presented: UISemiModalViewControllerTransitioning!
    private weak var container: UIView!
    
    private lazy var configuration: UISemiModalConfiguration = {
        return self.presented.configuration()
    }()
    
    private var isPresentation: Bool = true
    
    var statusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var dimmingAlpha: CGFloat {

        switch self.presented.state {
        case .semiModal: return self.presenter.isPresentedSemiModally ? 0 : UISemiModalConstants.dimmingAlpha
        case .modal, .fullscreen: return UISemiModalConstants.dimmingAlpha
        }
                
    }
    
    var cornerRadiusForPresentedView: CGFloat {
        
        switch self.presented.state {
        case .semiModal, .modal: return UISemiModalConstants.cardCornerRadius
        case .fullscreen: return 0
        }
        
    }

    var frameForPresentedViewInContainer: CGRect {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var contentHeight: CGFloat = self.container.bounds.height
        
        switch self.presented.state {
        case .semiModal: contentHeight = (self.container.bounds.height / 2)
        case .modal:
            
            switch self.configuration.style.rawStyle {
            case .card: contentHeight -= (statusBarHeight + UISemiModalConstants.cardStackOffset)
            case .cover: contentHeight -= statusBarHeight
            }
            
        case .fullscreen: break
        }
        
        let yOffset = (self.container.bounds.height - contentHeight)
        
        return CGRect(
            x: 0,
            y: yOffset,
            width: self.container.bounds.width,
            height: contentHeight
        )
        
    }
    
    init(presenter: UIViewController,
         presented: UISemiModalViewControllerTransitioning,
         container: UIView) {
        
        self.presenter = presenter
        self.presented = presented
        self.container = container
        
        // Style setup
        
        self.presenter.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.presenter.view.layer.masksToBounds = true
        
        self.presented.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.presented.view.layer.masksToBounds = true
        
    }
    
    func set(presentation: Bool) {
        self.isPresentation = presentation
    }
    
    func transformPresentingView() {

        let view = targetViewForPresenterTransform()
        view.transform = presenterTransform()
        
        // Corner radius
        
        var cornerRadius: CGFloat = 0
        
        switch self.presented.state {
        case .semiModal: cornerRadius = self.presenter.isPresentedSemiModally ? UISemiModalConstants.cardCornerRadius : 0
        case .modal, .fullscreen:
            
            switch self.configuration.style.rawStyle {
            case .card: cornerRadius = UISemiModalConstants.cardCornerRadius
            default: break
            }
            
        }
        
        view.layer.cornerRadius = cornerRadius
        
    }
    
    // MARK: Private
    
    private func targetViewForPresenterTransform() -> UIView {
        
        var view: UIView?
        
        if let semiModalPresenter = self.presenter as? UISemiModalViewControllerTransitioning {
            
            switch self.presented.state {
            case .semiModal: view = semiModalPresenter.view
            case .modal, .fullscreen: view = _firstFullscreenAncestor(in: self.presented)?.view
            }
            
        }
        
        return view ?? self.presenter.view
        
    }
    
    private func _firstFullscreenAncestor(in decendant: UIViewController) -> UIViewController? {
        
        guard let parent = decendant.presentingViewController else { return nil }
        
        if let semiModalParent = parent as? UISemiModalViewControllerTransitioning {
            
            switch semiModalParent.state {
            case .semiModal: return _firstFullscreenAncestor(in: semiModalParent)
            case .modal, .fullscreen: return semiModalParent
            }
            
        }
        
        return parent
        
    }
    
    private func presenterTransform() -> CGAffineTransform {
                
        if let semiModalPresenter = self.presenter as? UISemiModalViewControllerTransitioning {
            return _semiModalPresenterTransform(semiModalPresenter)
        }
        
        guard self.isPresentation else{ return .identity }
        
        switch self.presented.state {
        case .modal:
            
            switch presented.style.rawStyle {
            case .card:
                
                let height = presenter.view.bounds.height
                let scaledHeight = (height * UISemiModalConstants.cardScale)
                let topOffset = ((height - scaledHeight) / 2)
                let desiredTopOffset = UIApplication.shared.statusBarFrame.height
                let topOffsetAdjustment = (desiredTopOffset - topOffset)

                return CGAffineTransform(
                    scaleX: UISemiModalConstants.cardScale,
                    y: UISemiModalConstants.cardScale
                ).translatedBy(x: 0, y: topOffsetAdjustment)
                
            default: break
            }
            
        default: break
        }
        
        return .identity
        
    }
    
    private func _semiModalPresenterTransform(_ semiModalPresenter: UISemiModalViewControllerTransitioning) -> CGAffineTransform {
        
        guard self.isPresentation else{ return .identity }

        switch self.presented.state {
        case .semiModal:
            
            if semiModalPresenter.state == .semiModal,
                self.presented.style.rawStyle == .card {
                
                let height = presenter.view.bounds.height
                let scaledHeight = (height * UISemiModalConstants.cardScale)
                let topOffset = ((height - scaledHeight) / 2)
                let topOffsetAdjustment = -(topOffset + UISemiModalConstants.cardStackOffset)

                return CGAffineTransform(
                    scaleX: UISemiModalConstants.cardScale,
                    y: UISemiModalConstants.cardScale
                ).translatedBy(x: 0, y: topOffsetAdjustment)
                
            }
            
            return .identity
            
        case .modal:
            
            if semiModalPresenter.state == .modal,
                self.presented.style.rawStyle == .card {
                
                let height = presenter.view.bounds.height
                let scaledHeight = (height * UISemiModalConstants.cardScale)
                let topOffset = ((height - scaledHeight) / 2)
                let topOffsetAdjustment = -(topOffset + UISemiModalConstants.cardStackOffset)

                return CGAffineTransform(
                    scaleX: UISemiModalConstants.cardScale,
                    y: UISemiModalConstants.cardScale
                ).translatedBy(x: 0, y: topOffsetAdjustment)
                
            }
            
            return .identity
            
        case .fullscreen: return .identity
        }
        
    }
    
}
