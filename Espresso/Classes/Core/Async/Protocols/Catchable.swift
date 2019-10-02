//
//  Catchable.swift
//  Espresso
//
//  Created by Mitch Treece on 9/25/19.
//

import Foundation

public protocol Catchable {
    //
}

public extension Catchable where Self: Awaitable /* Catch */ {
    
    @discardableResult
    func `catch`(on queue: DispatchQueue = .main, _ body: @escaping (Error)->()) -> Cauterizer {

        let cauterizer = Cauterizer()
        
        self.await(on: queue) { result in
            
            switch result {
            case .success: cauterizer.cauterize()
            case .failure(let error):
                
                body(error)
                cauterizer.cauterize()
                
            }
            
        }
        
        return cauterizer
        
    }
    
    @discardableResult
    func `catch`<E: Error>(type: E.Type, _ body: @escaping (E)->()) -> Cauterizer {
        
        return self.catch { error in
            
            if let e = error as? E {
                body(e)
            }
            
        }
        
    }
    
}
