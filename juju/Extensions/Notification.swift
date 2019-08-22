//
//  Notification.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension Notification {
    
    var keyboardHeight: CGFloat {
        
        guard let userInfo = self.userInfo else {
            return .leastNormalMagnitude
        }
        
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            fatalError("The UIKeyboardFrameBeginUserInfoKey from keyboard cannot cast to NSValue")
        }
        
        let size = keyboardFrame.cgSizeValue
        return size.height
        
    }
    
}
