//
//  FirebaseQuery.swift
//  juju
//
//  Created by Antonio Rodrigues on 11/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FirebaseQuery {
    
    var firebaseQuery: Query { get }
}
