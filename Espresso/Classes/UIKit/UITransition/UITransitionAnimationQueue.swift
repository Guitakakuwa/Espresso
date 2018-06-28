//
//  UITransitionAnimationQueue.swift
//  Espresso
//
//  Created by Mitch Treece on 6/28/18.
//

import Foundation

internal class UITransitionAnimationQueue: OperationQueue {
    
    override init() {
        
        super.init()
        self.maxConcurrentOperationCount = 1
        
    }
    
}
