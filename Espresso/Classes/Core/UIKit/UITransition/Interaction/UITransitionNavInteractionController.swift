//
//  UITransitionNavInteractionController.swift
//  Director
//
//  Created by Mitch Treece on 10/27/19.
//

import UIKit

public final class UITransitionNavInteractionController: UITransitionInteractionController {
        
    public override func setup() {
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePan.edges = .left
        self.destinationViewController.view.addGestureRecognizer(edgePan)
        
    }
    
    @objc private func handleEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {

        let view = recognizer.view!
        let translation = recognizer.translation(in: view)
        let progress = min(1, max(0, (translation.x / view.bounds.width)))

        switch recognizer.state {
        case .began:

            self.isTransitioning = true
            self.destinationViewController.navigationController?.popViewController(animated: true)

        case .changed: self.update(progress)
        case .cancelled:

            self.isTransitioning = false
            cancel()

        case .ended:

            self.isTransitioning = false

            let velocity = recognizer.velocity(in: view)

            if (progress >= 0.5 || velocity.x > 0) {
                self.completionSpeed = 0.8
                finish()
            }
            else {
                cancel()
            }

        default: break
        }

    }
    
}
