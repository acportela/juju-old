//
//  ViewExtension.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIView {
    
    public func outlineRecursively(color: UIColor = .red, width: CGFloat = 1) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        
        for view in subviews {
            
            view.outlineRecursively(color: color, width: width)
        }
    }
}
