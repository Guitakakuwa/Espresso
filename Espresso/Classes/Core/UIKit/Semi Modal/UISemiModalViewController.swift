//
//  UISemiModalViewController.swift
//  Espresso
//
//  Created by Mitch Treece on 10/25/19.
//

import UIKit

open class UISemiModalViewController: UIBaseViewController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transition = UISemiModalTransition()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.transition = UISemiModalTransition()
    }
    
}
