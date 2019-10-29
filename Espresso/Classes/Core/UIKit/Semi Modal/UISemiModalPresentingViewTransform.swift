//
//  UISemiModalPresentingViewTransform.swift
//  Espresso
//
//  Created by Mitch Treece on 10/29/19.
//

import Foundation

internal struct UISemiModalPresentingViewTransform {
    
    static func `for`(presenter: UIViewController,
                      presented: UISemiModalViewControllerTransitioning,
                      inContainer container: UIView,
                      transition: UITransition.TransitionType) -> CGAffineTransform {
        
        if let semiModalPresenter = presenter as? UISemiModalViewControllerTransitioning {
            
            return _semiModalTransform(
                presenter: semiModalPresenter,
                presented: presented,
                inContainer: container,
                transition: transition
            )
            
        }
        
        return _transform(
            presenter: presenter,
            presented: presented,
            inContainer: container,
            transition: transition
        )
        
    }
    
    // MARK: Private
    
    private static func _transform(presenter: UIViewController,
                                   presented: UISemiModalViewControllerTransitioning,
                                   inContainer container: UIView,
                                   transition: UITransition.TransitionType) -> CGAffineTransform {
        
        guard transition == .presentation else { return .identity }
        
        switch presented.state {
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
                
            case .cover: return .identity
            }
            
        default: return .identity
        }
        
    }
    
    private static func _semiModalTransform(presenter: UISemiModalViewControllerTransitioning,
                                            presented: UISemiModalViewControllerTransitioning,
                                            inContainer container: UIView,
                                            transition: UITransition.TransitionType) -> CGAffineTransform {
        
        guard transition == .presentation else { return .identity }
        
        switch presented.state {
        case .semiModal:
            
            if presenter.state == .semiModal,
                presented.style.rawStyle == .card {
                
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
            
            if presenter.state == .modal,
                presented.style.rawStyle == .card {
                
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
    
    // MARK: Helpers
    
    private static func isFullscreenSemiModalAncestorVisible(in semiModal: UISemiModalViewControllerTransitioning) -> Bool {
        return false
    }
    
    private static func depth(of ancestor: UISemiModalViewControllerTransitioning,
                              in semiModal: UISemiModalViewControllerTransitioning) -> Int {
        return 0
    }
    
}
