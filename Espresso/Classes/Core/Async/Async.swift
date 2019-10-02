//
//  Async.swift
//  Espresso
//
//  Created by Mitch Treece on 9/24/19.
//

import Foundation

public final class Async<T>: AsyncProtocol {
    
    public typealias Task = ((Resolver<T>) throws -> ())
    
    private enum State: CustomStringConvertible {
        
        case pending(awaiters: [Awaiter<T>])
        case fulfilled(T)
        case rejected(Error)
        case cancelled
        
        public var isPending: Bool {
            
            switch self {
            case .pending: return true
            default: return false
            }
            
        }
        
        public var isFulfilled: Bool {
            
            switch self {
            case .fulfilled: return true
            default: return false
            }
            
        }
        
        public var isRejected: Bool {
            
            switch self {
            case .rejected: return true
            default: return false
            }
            
        }
        
        public var isCancelled: Bool {
            
            switch self {
            case .cancelled: return true
            default: return false
            }
            
        }
        
        public var value: T? {
            
            switch self {
            case .fulfilled(let value): return value
            default: return nil
            }
            
        }
        
        public var error: Error? {
            
            switch self {
            case .rejected(let error): return error
            case .cancelled: return AsyncError.Cancelled()
            default: return nil
            }
            
        }
        
        public var description: String {
            
            switch self {
            case .pending: return "pending"
            case .fulfilled(let value): return "fulfilled(\(value))"
            case .rejected(let error): return "rejected(\(error))"
            case .cancelled: return "cancelled"
            }
            
        }
        
    }
    
    private var state: State = .pending(awaiters: [])
    private let stateQueue = DispatchQueue(
        label: "com.mitchtreece.Control.async.state",
        qos: .userInitiated
    )
        
    internal lazy var resolver: Resolver<T> = {
       
        return Resolver<T> { result in
            switch result {
            case .success(let value): self.set(state: .fulfilled(value))
            case .failure(let error): self.set(state: .rejected(error))
            }
        }
        
    }()
    
    public var isPending: Bool {
        self.stateQueue.sync {
            return self.state.isPending
        }
    }
    
    public var isFulfilled: Bool {
        self.stateQueue.sync {
            return self.state.isFulfilled
        }
    }
    
    public var isRejected: Bool {
        self.stateQueue.sync {
            return self.state.isRejected
        }
    }
    
    public var isCancelled: Bool {
        self.stateQueue.sync {
            return self.state.isCancelled
        }
    }
    
    public var value: T? {
        self.stateQueue.sync {
            return self.state.value
        }
    }
    
    public var error: Error? {
        self.stateQueue.sync {
            return self.state.error
        }
    }
    
    // MARK: Initializers
    
    public init() {
        //
    }
    
    public init(value: T) {
        self.state = .fulfilled(value)
    }
    
    public init(error: Error) {
        self.state = .rejected(error)
    }
    
    public init(on queue: DispatchQueue = .global(qos: .userInitiated), _ task: @escaping Task) {
        
        queue.async {
            
            do {
                try task(self.resolver)
            }
            catch {
                
                if let _ = error as? AsyncError.Cancelled {
                    self.set(state: .cancelled)
                }
                else {
                    self.set(state: .rejected(error))
                }
                
            }
            
        }
        
    }
    
    // MARK: AsyncProtocol
    
    public func await(on queue: DispatchQueue, _ resolution: @escaping (Result<T, Error>)->()) {
        
        self.stateQueue.async(group: nil, qos: .userInitiated, flags: .barrier) {

            switch self.state {
            case .pending(var awaiters):
                
                let awaiter = Awaiter<T>(resolution)
                awaiters.append(awaiter)
                self.state = .pending(awaiters: awaiters)

            case .fulfilled(let value): resolution(.success(value))
            case .rejected(let error): resolution(.failure(error))
            case .cancelled: resolution(.failure(AsyncError.Cancelled()))
            }

        }
        
    }
    
    // MARK: Private
    
    private func set(state: State) {
        
        self.stateQueue.async {
            
            guard case .pending(let awaiters) = self.state else { return }
            self.state = state
            self.notify(awaiters: awaiters)
            
        }
        
    }
    
    private func notify(awaiters: [Awaiter<T>]) {
    
        guard !awaiters.isEmpty else { return }
        
        self.stateQueue.async {
            
            switch self.state {
            case .pending: break
            case .fulfilled(let value):
                
                var mutableAwaiters = awaiters
                let firstAwaiter = mutableAwaiters.removeFirst()
                firstAwaiter.deliver(.success(value))
                self.notify(awaiters: mutableAwaiters)
                
            case .rejected(let error):
                
                var mutableAwaiters = awaiters
                let firstAwaiter = mutableAwaiters.removeFirst()
                firstAwaiter.deliver(.failure(error))
                self.notify(awaiters: mutableAwaiters)
        
            case .cancelled:
                
                var mutableAwaiters = awaiters
                let firstAwaiter = mutableAwaiters.removeFirst()
                firstAwaiter.deliver(.failure(AsyncError.Cancelled()))
                self.notify(awaiters: mutableAwaiters)
                
            }
            
        }
        
    }
    
}
