//
//  UIButton.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setTitle(_ title: String = "", withColor color: UIColor, andFont font: UIFont, underlined: Bool = false) {
        
        let underlineStyle = underlined ? 1 : 0
        
        var attributes: [NSAttributedString.Key: Any] = [.underlineStyle: underlineStyle,
                                                         .font: font]
        
        attributes[.foregroundColor] = color
        let normalTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(normalTitle, for: .normal)

        attributes[.foregroundColor] = color.withAlphaComponent(0.5)
        let highlightedTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        attributes[.foregroundColor] = color.withAlphaComponent(0.3)
        let disabledTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(disabledTitle, for: .disabled)
    }
}
