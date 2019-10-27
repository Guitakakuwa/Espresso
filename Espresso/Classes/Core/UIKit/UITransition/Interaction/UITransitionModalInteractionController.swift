//
//  UITransitionModalInteractionController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/27/19.
//

import UIKit

public final class UITransitionModalInteractionController: UITransitionInteractionController {
    
    private var shouldFinish: Bool = false
    private var lastProgress: CGFloat?
    
    public override func setup() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.destinationViewController.view.addGestureRecognizer(pan)
        
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let view = recognizer.view!
        let translation = recognizer.translation(in: view.superview)
        
        // Represents the percentage of the transition that must be completed before allowing to complete.
        let progressThreshold: CGFloat = 0.2
        
        // Represents the difference between progress that is required to trigger the completion of the transition.
        let automaticOverrideThreshold: CGFloat = 0.03
        
        let totalPanAmount = UIScreen.main.bounds.height
        let progress = max(0, min(1, (translation.y / totalPanAmount)))

        switch recognizer.state {
        case .began:
            
//            switch self.transitionType {
//            case .presentation:
//
//                self.sourceViewController?.present(
//                    self.destinationViewController,
//                    animated: true,
//                    completion: nil
//                )
//
//            case .dismissal:
//
//                self.sourceViewController?.dismiss(
//                    animated: true,
//                    completion: nil
//                )
//
//            default: break
//            }
            
            if let _ = self.sourceViewController?.presentedViewController {
                
                self.sourceViewController?.dismiss(
                    animated: true,
                    completion: nil
                )
                
            }
            else {
                
                self.sourceViewController?.present(
                    self.destinationViewController,
                    animated: true,
                    completion: nil
                )
                
            }

        case .changed:
            
            guard let lastProgress = self.lastProgress else { return }
            
            if lastProgress > progress {
                self.shouldFinish = false
            }
            else if progress > (lastProgress + automaticOverrideThreshold) {
                self.shouldFinish = true
            }
            else {
                self.shouldFinish = (progress > progressThreshold)
            }
            
            update(progress)
            
        case .ended, .cancelled:
            
            if recognizer.state == .cancelled || self.shouldFinish == false {
                cancel()
            }
            else {
                finish()
            }
            
        default: break
        }
        
        self.lastProgress = progress
        
    }
    
}
