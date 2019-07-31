//
//  TextFieldValidators.swift
//  juju
//
//  Created by Antonio Rodrigues on 30/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

struct TextFieldValidators {
    
    static func lenghtHandler(textField: UITextField,
                              shouldChangeCharactersInRange range: NSRange,
                              replacementString string: String,
                              maxLength: Int) -> Bool {
        
        guard let text = textField.text else { return true }
        let count = text.utf8.count + string.utf8.count - range.length
        return count <= maxLength
    }
}
