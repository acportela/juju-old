//
//  UITextField.swift
//  juju
//
//  Created by Antonio Portela on 25/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UITextField {
    
    func configurePlaceholderWith(title: String, color: UIColor) {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        self.attributedPlaceholder = NSAttributedString(string: title, attributes: attributes)
    }
}
