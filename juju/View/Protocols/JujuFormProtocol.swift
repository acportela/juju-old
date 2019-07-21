//
//  JujuFormProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol JujuFormProtocol where Self: UIView {
    
    var inputs: [JujuInputField] { get }
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
}
