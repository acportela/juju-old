//
//  Snackbar.swift
//  juju
//
//  Created by Antonio Portela on 13/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

struct Snackbar {
    
    static func show(message: String,
                     backgroundColor: UIColor,
                     image: UIImage,
                     messageColor: UIColor = .white,
                     in view: UIView) {
        
        guard !message.isEmpty else {
            return
        }
        
        let snackbarView = SnackbarView(message: message,
                                        backgroundColor: backgroundColor,
                                        image: image,
                                        messageColor: messageColor)
        
        snackbarView.show(in: view)
        
    }
    
    static func showError(message: String,
                          in view: UIView) {
        
        self.show(message: message,
                  backgroundColor: Styling.Colors.rosyPink,
                  image: Resources.Images.clear,
                  in: view)
    }
    
    static func showSuccess(message: String,
                            in view: UIView) {
        
        self.show(message: message,
                  backgroundColor: Styling.Colors.softPink,
                  image: Resources.Images.checkSmall,
                  in: view)
    }
}
