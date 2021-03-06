//
//  RxViewModelViewController.swift
//  Espresso
//
//  Created by Mitch Treece on 11/3/18.
//

import UIKit
import RxSwift
import RxCocoa

/**
 An Rx-based `UIViewController` subclass that provides common properties & functions when backed by a view model.
 */
open class RxViewModelViewController<V: ViewModel>: UIViewModelViewController<V> {
    
    /// The view controller's model dispose bag.
    public private(set) var modelDisposeBag: DisposeBag!
    
    /// The view controller's component dispose bag.
    public private(set) var componentDisposeBag: DisposeBag!
    
    /// Flag indicating if binding functions have been called yet.
    /// This is used to determine if the binding should should happen when `viewWillAppear(animated:)` is called.
    private var isBinded: Bool = false
    
    open override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if !self.isBinded {
            
            self.isBinded = true
            bindComponents()
            bindModel()
            
        }
        
    }
    
    /**
     Binding function called once in `viewWillAppear(animated:)`. Override this to setup custom component bindings.
     
     The view controller's `componentDisposeBag` is created when this is called.
     Subclasses that override this function should call `super.bindComponents()` **before** accessing the `componentDisposeBag`.
     */
    open func bindComponents() {
        
        // Override me
        self.componentDisposeBag = DisposeBag()
        
    }
    
    /**
     Binding function called once in `viewWillAppear(animated:)`. Override this to setup custom component bindings.
     
     The view controller's `modelDisposeBag` is created when this is called.
     Subclasses that override this function should call `super.modelDisposeBag()` **before** accessing the `modelDisposeBag`.
     */
    open func bindModel() {
        
        // Override me
        self.modelDisposeBag = DisposeBag()
        
    }
    
}
