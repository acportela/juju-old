//
//  FirebasePersistable.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol FirebasePersistable {
    
    var path: String { get }
    init?(fromData data: [String: Any], id: String)
    func toDictionary() -> [String: Any]
    mutating func setId(_ id: String)
}
