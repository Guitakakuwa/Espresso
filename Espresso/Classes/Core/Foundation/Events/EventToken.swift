//
//  EventToken.swift
//  Espresso
//
//  Created by Mitch Treece on 9/20/19.
//

import Foundation

/// `Event` token class that can be used to identify a specific observer.
public class EventToken<V> {
    
    internal var observer: EventObserver<V>
    
    internal init(observer: EventObserver<V>) {
        self.observer = observer
    }
    
}
