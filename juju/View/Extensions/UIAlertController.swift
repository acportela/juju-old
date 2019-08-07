//
//  UIAlertController.swift
//  juju
//
//  Created by Antonio Rodrigues on 03/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String,
                     message: String,
                     primaryActionTitle: String,
                     secondaryActionTitle: String? = nil,
                     handler: ((UIAlertAction) -> Void)? = nil,
                     secondaryHandler: ((UIAlertAction) -> Void)? = nil) {
        
        self.init(title: title,
                  message: message,
                  preferredStyle: UIAlertController.Style.alert)
        
        let positiveAction = UIAlertAction(title: primaryActionTitle,
                                           style: .default,
                                           handler: handler)
        addAction(positiveAction)
        
        if let cancelTitle = secondaryActionTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: secondaryHandler)
            addAction(cancelAction)
        }
        
    }
}
