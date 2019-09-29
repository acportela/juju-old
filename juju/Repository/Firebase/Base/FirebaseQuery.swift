//
//  FirebaseQuery.swift
//  juju
//
//  Created by Antonio Rodrigues on 11/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol FirebaseQuery {
    
    var path: String { get }
    var uniqueField: String { get }
    var uniqueValue: String { get }
}
