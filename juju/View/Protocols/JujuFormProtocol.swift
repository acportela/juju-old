//
//  JujuFormProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol JujuFormProtocol where Self: UIView {
    
    var inputs: [JujuInputField] { get }
    var fieldsAreValid: Bool { get }
    var inputStack: UIStackView { get }
    var onDoneAction: (() -> Void)? { get set }
    func setupToolbar(nextText: String, doneText: String)
}

extension JujuFormProtocol {
    
    func setupToolbar(nextText: String, doneText: String) {
        
        for (index, input) in inputs.enumerated() {
            
            let lastIndex = inputs.count - 1
            let isLastElement = index == lastIndex
            
            let title = isLastElement ? doneText : nextText
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
    
    var fieldsAreValid: Bool {
        
        for input in self.inputs where !input.isValid {
            
            return false
        }
        
        return true
    }
}
