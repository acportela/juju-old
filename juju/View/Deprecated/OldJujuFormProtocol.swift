//
//  OldJujuFormProtocol.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol OldJujuFormProtocol: KeyboardListenerDelegate where Self: UIView {
    
    var inputs: [JujuInputField] { get }
    var firstResponder: JujuInputField? { get }
    var fieldsAreValid: Bool { get }
    var inputStack: UIStackView { get }
    var scrollInputStack: UIScrollView { get }
    var onDoneAction: (() -> Void)? { get set }
    func setupToolbar()
}

extension OldJujuFormProtocol {
    
    func setupToolbar() {
        
        for (index, input) in inputs.enumerated() {
            
            let lastIndex = inputs.count - 1
            let isLastElement = index == lastIndex
            
            let title = isLastElement ? "Entrar" : "Próximo"
            let action: (() -> Void) = { [weak self] in
                
                if isLastElement {
                    self?.onDoneAction?()
                    input.resignFirstResponder()
                    return
                }
                
                self?.inputs[index + 1].becomeFirstResponder()
            }
            
            input.addToolbar(withButton: title, andAction: action)
        }
    }
    
    var firstResponder: JujuInputField? {
        
        for input in inputs where input.isFirstResponder {
            
            return input
        }
        
        return nil
    }
    
    var fieldsAreValid: Bool {
        
        for input in self.inputs where !input.isValid {
            
            return false
        }
        
        return true
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        
        if let validFirstResponder = firstResponder {
            
            let keyboardHeight = notification.keyboardHeight
            
            self.scrollInputStack.isScrollEnabled = true
            let scrollInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.scrollInputStack.contentInset = scrollInsets
            self.scrollInputStack.scrollIndicatorInsets = scrollInsets
            
            var containingRect = self.frame
            containingRect.size.height -= keyboardHeight

            if !containingRect.contains(validFirstResponder.frame.origin) {
                self.scrollInputStack.scrollRectToVisible(validFirstResponder.frame, animated: true)
            }
        }
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.2) {
            self.scrollInputStack.contentInset = .zero
            self.scrollInputStack.scrollIndicatorInsets = .zero
        }
    }
}

