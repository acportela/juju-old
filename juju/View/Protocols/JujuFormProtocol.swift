//
//  JujuFormProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol JujuFormProtocol: KeyboardListenerDelegate where Self: UIView {
    
    var inputs: [JujuInputField] { get }
    var firstResponder: JujuInputField? { get }
    
    var inputStack: UIStackView { get }
    var inputStackCenterY: SnapKit.Constraint? { get set }
    var inputStackCurrentOffset: CGFloat { get set }
    
    var onDoneAction: (() -> Void)? { get set }
    
    func setupToolbar()
}

extension JujuFormProtocol {
    
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
    
    func keyboardWillAppear(_ notification: Notification) {
        
        if let firstResponder = firstResponder {
            
            let keyboardMinY = self.frame.maxY - (notification.keyboardHeight + 8)
            
            let keyboardMinYInStacksCoordinate = keyboardMinY - inputStack.frame.minY
            let responderMaxYInStacksCoordinate = firstResponder.frame.maxY
            
            let difference = responderMaxYInStacksCoordinate - keyboardMinYInStacksCoordinate
            
            if difference > 0 {
                
                inputStackCurrentOffset += difference
            } else {
                
                inputStackCurrentOffset = 0
            }
        }
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        
        inputStackCurrentOffset = 0
    }
}
