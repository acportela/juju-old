//
//  Animatable.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol Animatable {
    
    func setup(hostView: UIView)
    func start()
    func stop()
}
