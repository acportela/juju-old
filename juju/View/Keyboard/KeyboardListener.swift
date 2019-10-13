//
//  KeyboardListener.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

public protocol KeyboardListenerDelegate: class {
    
    func keyboardWillAppear(_ notification: Notification)
    func keyboardWillDisappear(_ notification: Notification)
}

public class KeyboardListener: NSObject {
    
    public static let shared = KeyboardListener()
    public var keyboardHeight: CGFloat
    
    private var delegates: [KeyboardListenerDelegate] = []
    
    private override init() {
        self.keyboardHeight = .leastNonzeroMagnitude
        super.init()
        self.prepare()
    }
    
    public func register(_ delegate: KeyboardListenerDelegate) {
        delegates.append(delegate)
    }
    
    public func remove(_ delegate: KeyboardListenerDelegate) {
        if let i = delegates.firstIndex(where: { $0 === delegate }) {
            delegates.remove(at: i)
        }
    }
    
    @objc
    private func keyboardDidAppear(notification: Notification) {
        
        self.keyboardHeight = notification.keyboardHeight
        
        for delegate in delegates {
            delegate.keyboardWillAppear(notification)
        }
    }
    
    @objc
    private func keyboardWillDisappear(notification: Notification) {
        
        self.keyboardHeight = .leastNonzeroMagnitude
        
        for delegate in delegates {
            delegate.keyboardWillDisappear(notification)
        }
    }
    
    private func prepare() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidAppear(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisappear(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
}
