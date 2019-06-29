//
//  ViewConfiguration.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol ViewConfiguration {
    associatedtype States
    func configure(with: States)
}
