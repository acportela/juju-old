//
//  CAShapeLayer.swift
//  juju
//
//  Created by Antonio Portela on 08/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    convenience public init(center: CGPoint, radius: Float, fillColor: UIColor) {
        
        self.init()
        self.fillColor = fillColor.cgColor
        self.path = UIBezierPath(arcCenter: center,
                                 radius: CGFloat(radius),
                                 startAngle: 0,
                                 endAngle: 360,
                                 clockwise: true).cgPath
    }
}
