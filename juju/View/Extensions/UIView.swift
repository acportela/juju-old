//
//  UIView.swift
//  juju
//
//  Created by Antonio Portela on 13/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor,
                   opacity: Float,
                   radius: CGFloat,
                   offset: CGSize,
                   clipsToBounds: Bool? = nil,
                   masksToBounds: Bool? = nil) {
        
        if let masksToBounds = masksToBounds {
            
            layer.masksToBounds = masksToBounds
        }
        
        if let clipsToBounds = clipsToBounds {
            
            self.clipsToBounds = clipsToBounds
        }
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
