//
//  UIViewController+Espresso.swift
//  Espresso
//
//  Created by Mitch Treece on 2/16/19.
//

import UIKit

public extension Identifiable where Self: UIViewController /* Storyboard */ {
    
    /**
     Initializes a new instance of the view controller from a storyboard.
     
     - Parameter name: The storyboard's name; _defaults to \"Main\"_.
     - Parameter identifier: The view controller's storyboard identifier. If no identifier is provided, the class name will be used; _defaults to nil_.
     - Returns: A typed storyboard-loaded view controller instance.
     */
    static func initFromStoryboard(named name: String = "Main", identifier: String? = nil) -> Self? {
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = identifier ?? self.identifier
        return storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        
    }
    
}

public extension UIViewController /* Debug */ {
    
    private var esp_parentViewController: UIViewController {
        
        var root = self

        while let parent = root.parent {
            root = parent
        }

        return root
        
    }
    
    func esp_assertDealloc(after delay: TimeInterval = 2) {
        
        let parentViewController = self.esp_parentViewController

        // We don’t check `isBeingDismissed` simply on this view controller because it’s common
        // to wrap a view controller in another view controller (e.g. in UINavigationController)
        // and present the wrapping view controller instead.
        
        if self.isMovingFromParent || parentViewController.isBeingDismissed {
            
            let _type = type(of: self)
            let context = self.isMovingFromParent ? "removal" : "dismissal"

            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                assert(self == nil, "\(_type) not deallocated after \(context)")
            })
            
        }
        
    }
    
}
