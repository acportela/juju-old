//
//  ContentResult.swift
//  juju
//
//  Created by Antonio Rodrigues on 16/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum ContentResult<T, E: Error> {

    case success(T)
    case error(E)
}

enum Result<E: Error> {
    
    case success
    case error(E)
}
