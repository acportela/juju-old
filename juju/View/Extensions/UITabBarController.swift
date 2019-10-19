//
//  UITabBarController.swift
//  juju
//
//  Created by Antonio Rodrigues on 19/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func setSuccessStateWithMessage(_ message: String) {
        
        guard let hostView = self.selectedViewController?.view else { return }
        Snackbar.showSuccess(message: message, in: hostView)
    }
    
    func setErrorStateWithMessage(_ message: String) {
        
        guard let hostView = self.selectedViewController?.view else { return }
        Snackbar.showError(message: message, in: hostView)
    }
}
